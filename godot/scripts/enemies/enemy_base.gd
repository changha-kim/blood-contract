extends CharacterBody2D
# NOTE: Avoid global class_name registration to prevent editor cache/name conflicts.
# Other scripts should extend this base via explicit path.

enum Phase {
	CHOOSE_INTENT,
	TELEGRAPH,
	COMMIT,
	EXECUTE,
	RECOVER,
}

@export var enemy_id: String = ""
@export var target_path: NodePath
@export var move_speed: float = 160.0

@onready var health: HealthComponent = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var attack_root: Node2D = $Attack
@onready var hitbox: Hitbox = $Attack/Hitbox
@onready var telegraph: TelegraphIndicator = get_node_or_null("TelegraphIndicator") as TelegraphIndicator
@onready var knockback: KnockbackComponent = get_node_or_null("Knockback") as KnockbackComponent

var target: Node2D

var phase: Phase = Phase.CHOOSE_INTENT
var _phase_left: float = 0.0

var _intent_id: String = ""
var _locked_dir: Vector2 = Vector2.RIGHT
var _execute_hit: bool = false

# Commit cue + micro-slow controls (TC01 readability patch)
var _commit_cue_fired_this_commit: bool = false
var _micro_slow_active: bool = false
var _prev_time_scale: float = 1.0

func _ready() -> void:
	add_to_group("targetable")
	target = get_node_or_null(target_path) as Node2D
	health.died.connect(queue_free)
	hitbox.hit_hurtbox.connect(_on_hitbox_hurtbox)
	hitbox.owner_id = enemy_id
	hitbox.source_id = enemy_id
	_apply_enemy_data()
	_set_phase(Phase.CHOOSE_INTENT, 0.1)

func _physics_process(delta: float) -> void:
	_phase_left -= delta
	if _phase_left <= 0.0:
		_advance_phase()

	match phase:
		Phase.CHOOSE_INTENT, Phase.RECOVER:
			_update_pursuit(delta)
		Phase.TELEGRAPH:
			_update_aim_telegraph()
			_update_pursuit(delta)
		Phase.COMMIT:
			_update_commit_hold(delta)
		Phase.EXECUTE:
			_update_execute(delta)

func get_intent_id() -> String:
	return _intent_id

func is_in_execute() -> bool:
	return phase == Phase.EXECUTE

# ---- Phase machine ----
func _advance_phase() -> void:
	match phase:
		Phase.CHOOSE_INTENT:
			# Only start the intent loop once we are in range.
			var dist: float = 999999.0
			if target != null:
				dist = (target.global_position - global_position).length()
			if target == null or not _can_start_intent(dist):
				_set_phase(Phase.CHOOSE_INTENT, 0.10)
				return
			_intent_id = _choose_intent()
			EventLogger.log_event("intent_choose", {"enemy_id": enemy_id, "intent_id": _intent_id})
			_set_phase(Phase.TELEGRAPH, _get_intent_float(_intent_id, "telegraph_sec", 0.55))
		Phase.TELEGRAPH:
			_commit_intent()
			_set_phase(Phase.COMMIT, _get_intent_float(_intent_id, "commit_sec", 0.20))
		Phase.COMMIT:
			_begin_execute()
			_set_phase(Phase.EXECUTE, _get_intent_float(_intent_id, "execute_sec", 0.10))
		Phase.EXECUTE:
			_end_execute()
			EventLogger.log_event("intent_execute", {"enemy_id": enemy_id, "intent_id": _intent_id, "hit": _execute_hit})
			_set_phase(Phase.RECOVER, _get_intent_float(_intent_id, "recover_sec", 0.70))
		Phase.RECOVER:
			_set_phase(Phase.CHOOSE_INTENT, 0.05)

func _set_phase(p: Phase, duration_sec: float) -> void:
	phase = p
	_phase_left = maxf(0.01, duration_sec)
	_on_phase_entered(p)

func _on_phase_entered(p: Phase) -> void:
	match p:
		Phase.CHOOSE_INTENT:
			hitbox.monitoring = false
			if telegraph != null:
				telegraph.set_visible_telegraph(false)
				telegraph.set_commit_locked(false)
		Phase.TELEGRAPH:
			_execute_hit = false
			_commit_cue_fired_this_commit = false
			if telegraph != null:
				telegraph.set_visible_telegraph(true)
				telegraph.set_commit_locked(false)
				telegraph.set_style_telegraph()
			_update_aim_telegraph()
			var dmg := _get_intent_int(_intent_id, "damage", hitbox.damage)
			var shape := _get_intent_string(_intent_id, "shape", "line")
			EventLogger.log_event("intent_telegraph", {"enemy_id": enemy_id, "intent_id": _intent_id, "dmg": dmg, "shape": shape})
		Phase.COMMIT:
			if telegraph != null:
				telegraph.set_visible_telegraph(true)
				telegraph.set_commit_locked(true) # fires LOCK + SFX (once) via TelegraphIndicator
				telegraph.set_style_commit()      # SOLID/thick style
			var lock_dir := _locked_dir
			if lock_dir.length_squared() < 0.001:
				lock_dir = Vector2.RIGHT
			var now_msec: int = Time.get_ticks_msec()
			# Existing intent_commit event (baseline)
			EventLogger.log_event("intent_commit", {
				"enemy_id": enemy_id,
				"intent_id": _intent_id,
				"lock_type": _get_lock_type(),
				"lock_vector": {"x": lock_dir.x, "y": lock_dir.y},
			})
			# LOG-001 alias for Week1 schema alignment.
			EventLogger.log_event("commit_enter", {
				"run_id": RunManager.current_run_id,
				"enemy_id": enemy_id,
				"intent_id": _intent_id,
				"ts_msec": now_msec,
			})
			_fire_commit_cue_once()
			_apply_commit_micro_slow()
		Phase.EXECUTE:
			if telegraph != null:
				telegraph.set_visible_telegraph(false)
		Phase.RECOVER:
			hitbox.monitoring = false
			if telegraph != null:
				telegraph.set_visible_telegraph(false)
				telegraph.set_commit_locked(false)
			EventLogger.log_event("intent_recover", {"enemy_id": enemy_id, "intent_id": _intent_id})

# ---- Movement / aiming ----
func _update_pursuit(delta: float) -> void:
	if target == null:
		velocity = _compose_velocity(Vector2.ZERO, delta)
		move_and_slide()
		return
	var to_t := (target.global_position - global_position)
	var dist := to_t.length()
	var v := Vector2.ZERO
	if phase == Phase.CHOOSE_INTENT:
		if _can_start_intent(dist):
			velocity = _compose_velocity(Vector2.ZERO, delta)
			move_and_slide()
			return
		v = to_t.normalized() * move_speed
	elif phase in [Phase.TELEGRAPH, Phase.RECOVER]:
		# Hold a bit for readability.
		v = Vector2.ZERO
	velocity = _compose_velocity(v, delta)
	move_and_slide()

func _update_commit_hold(delta: float) -> void:
	velocity = _compose_velocity(Vector2.ZERO, delta)
	move_and_slide()

func _compose_velocity(base_vel: Vector2, delta: float) -> Vector2:
	var v := base_vel
	if knockback != null:
		v += knockback.get_velocity(delta)
	return v

func _update_aim_telegraph() -> void: 
	var dir := _get_desired_dir_to_target() 
	if dir.length_squared() > 0.001: 
		_locked_dir = dir 
	attack_root.rotation = _locked_dir.angle() 
	if telegraph != null:
		telegraph.set_direction(_locked_dir) 
 
func _commit_intent() -> void: 
	# Default lock rule: direction lock. 
	var dir := _get_desired_dir_to_target() 
	if dir.length_squared() > 0.001: 
		_locked_dir = dir 
	attack_root.rotation = _locked_dir.angle() 
	if telegraph != null:
		telegraph.set_direction(_locked_dir) 

func _fire_commit_cue_once() -> void:
	if _commit_cue_fired_this_commit:
		return
	_commit_cue_fired_this_commit = true
	var now_ms: int = Time.get_ticks_msec()
	# New instrumentation (commit entry should match intent_commit count)
	Telemetry.log_event("commit_cue_fired", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"ts_ms": now_ms,
	})
	# Also mirror into run_*.jsonl for easier QA comparison with intent_commit.
	EventLogger.log_event("commit_cue_fired", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"ts_ms": now_ms,
	})

func _apply_commit_micro_slow() -> void:
	var ux := DataRepo.get_combat_ux()
	var enabled: bool = bool(ux.get("commitMicroSlowEnabled", false))
	if not enabled:
		return
	if _micro_slow_active:
		return
	var duration: float = float(ux.get("commitMicroSlowDuration", 0.1))
	duration = clampf(duration, 0.0, 0.1)
	if duration <= 0.0:
		return
	var time_scale: float = float(ux.get("commitMicroSlowTimeScale", 0.2))
	time_scale = clampf(time_scale, 0.05, 1.0)
	_micro_slow_active = true
	_prev_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	Telemetry.log_event("commit_micro_slow_start", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"prev_time_scale": _prev_time_scale,
		"time_scale": time_scale,
		"duration": duration,
	})
	EventLogger.log_event("commit_micro_slow_start", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"prev_time_scale": _prev_time_scale,
		"time_scale": time_scale,
		"duration": duration,
	})
	# Use a real-time timer so restore timing is not affected by time_scale.
	var t := get_tree().create_timer(duration, false, false, true)
	await t.timeout
	Engine.time_scale = _prev_time_scale
	Telemetry.log_event("commit_micro_slow_end", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"time_scale": _prev_time_scale,
	})
	EventLogger.log_event("commit_micro_slow_end", {
		"enemy_id": enemy_id,
		"intent_id": _intent_id,
		"time_scale": _prev_time_scale,
	})
	_micro_slow_active = false

func _begin_execute() -> void:
	hitbox.monitoring = true

func _update_execute(delta: float) -> void:
	# Default: no movement.
	velocity = _compose_velocity(Vector2.ZERO, delta)
	move_and_slide()

func _end_execute() -> void:
	hitbox.monitoring = false

func _on_hitbox_hurtbox(hb: Hurtbox) -> void:
	if hb != null and hb.faction == "PLAYER":
		_execute_hit = true

# ---- Data / overrides ----
func _choose_intent() -> String:
	# Override in subclasses.
	return ""

func _get_lock_type() -> String:
	return "direction"

func _can_start_intent(dist_to_target_px: float) -> bool:
	# Override in subclasses.
	return dist_to_target_px <= 180.0

func _get_desired_dir_to_target() -> Vector2:
	if target == null:
		return Vector2.ZERO
	var d := (target.global_position - global_position)
	if d.length_squared() < 0.001:
		return Vector2.ZERO
	return d.normalized()

func _get_intent_def(intent_id: String) -> Dictionary:
	return {}

func _get_intent_float(intent_id: String, key: String, fallback: float) -> float:
	var d := _get_intent_def(intent_id)
	if d.has(key):
		return float(d[key])
	return fallback

func _get_intent_int(intent_id: String, key: String, fallback: int) -> int:
	var d := _get_intent_def(intent_id)
	if d.has(key):
		return int(d[key])
	return fallback

func _get_intent_string(intent_id: String, key: String, fallback: String) -> String:
	var d := _get_intent_def(intent_id)
	if d.has(key):
		return str(d[key])
	return fallback

func _apply_enemy_data() -> void:
	# Optional shared loading.
	pass

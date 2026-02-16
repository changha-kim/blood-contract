extends CharacterBody2D
# NOTE: _wip version must not register the same global class_name as the live script.
# Keeping this file for reference, but avoid Godot parser conflict.
# class_name EnemyBase

signal intent_committed(intent_name: String)

enum IntentState {
	CHOOSE_INTENT,
	TELEGRAPH,
	COMMIT,
	EXECUTE,
	RECOVER,
}

@export var enemy_id: String = ""
@export var move_speed: float = 160.0

@onready var health: HealthComponent = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var attack_root: Node2D = $Attack
@onready var hitbox: Hitbox = $Attack/Hitbox
@onready var telegraph_root: Node2D = $Telegraph
@onready var knockback: KnockbackComponent = get_node_or_null("Knockback") as KnockbackComponent

var _state: IntentState = IntentState.CHOOSE_INTENT
var _state_left: float = 0.0

var target: Node2D
var _locked_facing: Vector2 = Vector2.RIGHT
var _intent_name: String = ""

var _last_intent_commit_msec: int = 0
var _stun_left: float = 0.0

func _ready() -> void:
	_apply_enemy_data()
	health.died.connect(queue_free)
	_set_state(IntentState.CHOOSE_INTENT, 0.1)

func _physics_process(delta: float) -> void:
	_state_left -= delta
	_stun_left = maxf(0.0, _stun_left - delta)
	if _state_left <= 0.0:
		_advance_state()

	match _state:
		IntentState.TELEGRAPH:
			_update_telegraph()
		IntentState.COMMIT:
			# LOCKED: no aim updates besides visuals.
			pass
		IntentState.EXECUTE:
			_execute_movement(delta)
			pass
		_:
			_execute_movement(delta)

func apply_stun(duration_sec: float) -> void:
	_stun_left = maxf(_stun_left, duration_sec)

func is_stunned() -> bool:
	return _stun_left > 0.0

func get_last_intent_commit_msec() -> int:
	return _last_intent_commit_msec

func get_intent_id() -> String:
	return _intent_name

func is_in_execute() -> bool:
	return _state == IntentState.EXECUTE

func _execute_movement(delta: float) -> void:
	if is_stunned():
		velocity = _compose_velocity(Vector2.ZERO, delta)
		move_and_slide()
		return

	# For PoC: minimal pursuit during choose/telegraph/recover.
	if target == null:
		velocity = _compose_velocity(Vector2.ZERO, delta)
		move_and_slide()
		return
	var to_t := (target.global_position - global_position)
	var base_vel := Vector2.ZERO
	if to_t.length() > 4.0 and _state in [IntentState.CHOOSE_INTENT, IntentState.TELEGRAPH, IntentState.RECOVER]:
		base_vel = to_t.normalized() * move_speed
	velocity = _compose_velocity(base_vel, delta)
	move_and_slide()

func _compose_velocity(base_vel: Vector2, delta: float) -> Vector2:
	var v := base_vel
	if knockback != null:
		v += knockback.get_velocity(delta)
	return v

func _advance_state() -> void:
	match _state:
		IntentState.CHOOSE_INTENT:
			_choose_intent()
			_set_state(IntentState.TELEGRAPH, get_telegraph_sec())
		IntentState.TELEGRAPH:
			_commit_intent()
			_set_state(IntentState.COMMIT, get_commit_sec())
		IntentState.COMMIT:
			_set_state(IntentState.EXECUTE, get_execute_sec())
			_begin_execute()
		IntentState.EXECUTE:
			_end_execute()
			_set_state(IntentState.RECOVER, get_recover_sec())
		IntentState.RECOVER:
			_set_state(IntentState.CHOOSE_INTENT, 0.05)

func _set_state(s: IntentState, duration_sec: float) -> void:
	_state = s
	_state_left = maxf(0.01, duration_sec)
	_on_state_entered(s)

func _on_state_entered(s: IntentState) -> void:
	match s:
		IntentState.CHOOSE_INTENT:
			telegraph_root.visible = false
			hitbox.monitoring = false
		IntentState.TELEGRAPH:
			telegraph_root.visible = true
			_set_telegraph_style(Color(1, 0.6, 0.1, 0.7), 6.0)
			EventLogger.log_event("intent_telegraph", {"enemy_id": enemy_id, "intent_id": _intent_name})
		IntentState.COMMIT:
			telegraph_root.visible = true
			_set_telegraph_style(Color(1, 0.1, 0.1, 0.85), 10.0)
			_last_intent_commit_msec = Time.get_ticks_msec()
			EventLogger.log_event("intent_commit", {"enemy_id": enemy_id, "intent_id": _intent_name})
			intent_committed.emit(_intent_name)
		IntentState.EXECUTE:
			telegraph_root.visible = false
			EventLogger.log_event("intent_execute", {"enemy_id": enemy_id, "intent_id": _intent_name})
		IntentState.RECOVER:
			hitbox.monitoring = false
			EventLogger.log_event("intent_recover", {"enemy_id": enemy_id, "intent_id": _intent_name})

func _set_telegraph_style(color: Color, width: float) -> void:
	var line := telegraph_root.get_node_or_null("TelegraphArc") as Line2D
	if line != null:
		line.default_color = color
		line.width = width

func _choose_intent() -> void:
	_intent_name = "SLASH"
	if target != null:
		_locked_facing = (target.global_position - global_position).normalized()
		if _locked_facing.length_squared() < 0.001:
			_locked_facing = Vector2.RIGHT

func _update_telegraph() -> void:
	# During telegraph, we can still update aiming a bit (assist readability).
	if target != null:
		var face := (target.global_position - global_position).normalized()
		if face.length_squared() > 0.001:
			_locked_facing = face
	attack_root.rotation = _locked_facing.angle()
	telegraph_root.rotation = _locked_facing.angle()

func _commit_intent() -> void:
	# LOCK: no more changes to facing/target selection.
	attack_root.rotation = _locked_facing.angle()
	telegraph_root.rotation = _locked_facing.angle()

func _begin_execute() -> void:
	# Default: a short hitbox pulse.
	hitbox.monitoring = true

func _end_execute() -> void:
	hitbox.monitoring = false

# Tunables (override per enemy)
func get_telegraph_sec() -> float:
	return 0.5

func get_commit_sec() -> float:
	return 0.2

func get_execute_sec() -> float:
	return 0.1

func get_recover_sec() -> float:
	return 0.6

func _apply_enemy_data() -> void:
	if enemy_id == "":
		return
	var defs := DataRepo.get_enemy_defs()
	var d := defs.get(enemy_id, {}) as Dictionary
	if d.has("max_hp"):
		health.max_hp = int(d["max_hp"])
		health.set_full_health()

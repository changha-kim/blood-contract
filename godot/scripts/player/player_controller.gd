extends CharacterBody2D
class_name PlayerController

@onready var health: HealthComponent = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var attack_root: Node2D = $Attack
@onready var hitbox: Hitbox = $Attack/Hitbox

# Tunables (loaded from data/defs/CombatTuning.json)
var move_speed: float = 340.0
var hitbox_active_sec: float = 0.09
var auto_aim_range_px: float = 220.0

var dash_speed: float = 900.0
var dash_duration_sec: float = 0.12
var dash_cooldown_sec: float = 0.85
var dash_invuln_sec: float = 0.18

# State
var move_dir: Vector2 = Vector2.ZERO
var _facing_dir: Vector2 = Vector2.RIGHT
var _was_moving: bool = false

var _dash_time_left: float = 0.0
var _dash_cooldown_left: float = 0.0
var _dash_dir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	add_to_group("player")
	hurtbox.faction = "PLAYER"
	hurtbox.entity_id = "player"
	hitbox.owner_faction = "PLAYER"
	hitbox.owner_id = "player"
	_apply_tuning()

func _physics_process(delta: float) -> void:
	_read_keyboard_input()
	_update_facing_from_move_dir()
	_update_movement_telemetry()

	if _dash_cooldown_left > 0.0:
		_dash_cooldown_left = maxf(0.0, _dash_cooldown_left - delta)

	if Input.is_action_just_pressed("attack_btn"):
		_do_attack()

	if Input.is_action_just_pressed("dash_btn"):
		_try_dash()

	if _dash_time_left > 0.0:
		_dash_time_left = maxf(0.0, _dash_time_left - delta)
		velocity = _dash_dir * dash_speed
		move_and_slide()
		if _dash_time_left <= 0.0:
			_end_dash()
		return

	velocity = move_dir * move_speed
	move_and_slide()

func set_move_dir(d: Vector2) -> void:
	# Optional external feed (VirtualJoystick). Keyboard input overwrites each frame.
	move_dir = d.limit_length(1.0)

func get_dash_cooldown_remaining() -> float:
	return _dash_cooldown_left

# Back-compat for HUD/debug widgets.
# "Skill1" currently maps to dash/shove.
func get_skill1_cooldown_left_sec() -> float:
	return _dash_cooldown_left

func is_dashing() -> bool:
	return _dash_time_left > 0.0

func _read_keyboard_input() -> void:
	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_dir = Vector2(x, y).limit_length(1.0)

func _update_facing_from_move_dir() -> void:
	if move_dir.length_squared() > 0.0001:
		_facing_dir = move_dir.normalized()

func _update_movement_telemetry() -> void:
	var moving: bool = move_dir.length_squared() > 0.0001
	if moving == _was_moving:
		return
	_was_moving = moving
	Telemetry.log_event("player_move", {
		"run_id": RunManager.current_run_id,
		"state": "start" if moving else "stop",
		"dir_x": _facing_dir.x,
		"dir_y": _facing_dir.y,
	})

func _do_attack() -> void:
	var target: Hurtbox = _find_nearest_target_hurtbox()
	if target != null:
		var dir := (target.global_position - global_position)
		if dir.length_squared() > 0.0001:
			_facing_dir = dir.normalized()

	attack_root.rotation = _facing_dir.angle()
	Telemetry.log_event("player_attack", {
		"run_id": RunManager.current_run_id,
		"target_id": target.entity_id if target != null else "",
	})
	_hitbox_pulse(hitbox_active_sec)

func _try_dash() -> void:
	if _dash_time_left > 0.0:
		return
	if _dash_cooldown_left > 0.0:
		return

	_dash_cooldown_left = dash_cooldown_sec
	_dash_time_left = dash_duration_sec
	_dash_dir = (move_dir if move_dir.length_squared() > 0.0001 else _facing_dir).normalized()

	# Invulnerability: explicit flag + extra i-frames to cover any overlap.
	hurtbox.invulnerable = true
	hurtbox.grant_i_frames(dash_invuln_sec)

	Telemetry.log_event("player_dash", {
		"run_id": RunManager.current_run_id,
		"dir_x": _dash_dir.x,
		"dir_y": _dash_dir.y,
	})

func _end_dash() -> void:
	hurtbox.invulnerable = false

func _hitbox_pulse(duration_sec: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration_sec).timeout
	hitbox.monitoring = false

func _find_nearest_target_hurtbox() -> Hurtbox:
	var best: Hurtbox = null
	var best_d2: float = auto_aim_range_px * auto_aim_range_px
	for n: Node in get_tree().get_nodes_in_group("targetable"):
		if n is not Node2D:
			continue
		var hb: Hurtbox = null
		# Convention: node has child named "Hurtbox".
		if n.has_node("Hurtbox"):
			hb = n.get_node("Hurtbox") as Hurtbox
		if hb == null:
			continue
		if hb.faction == hurtbox.faction:
			continue
		var d2 := (hb.global_position - global_position).length_squared()
		if d2 <= best_d2:
			best_d2 = d2
			best = hb
	return best

func _apply_tuning() -> void:
	# Preferred M1 defs (Sprint S1): player_core.json
	var player_def := DataRepo.get_dict("player_core")
	# Back-compat: older tuning file name/schema (CombatTuning.json)
	if player_def.is_empty():
		var root := DataRepo.get_dict("CombatTuning")
		player_def = (root.get("player", {}) as Dictionary)

	if player_def.has("move_speed"):
		move_speed = float(player_def["move_speed"])

	var attack_def := player_def.get("attack", {}) as Dictionary
	if attack_def.has("hitbox_active_sec"):
		hitbox_active_sec = float(attack_def["hitbox_active_sec"])
	if attack_def.has("auto_aim_range_px"):
		auto_aim_range_px = float(attack_def["auto_aim_range_px"])

	var dash_def := player_def.get("dash", {}) as Dictionary
	if dash_def.has("speed"):
		dash_speed = float(dash_def["speed"])
	if dash_def.has("duration_sec"):
		dash_duration_sec = float(dash_def["duration_sec"])
	if dash_def.has("cooldown_sec"):
		dash_cooldown_sec = float(dash_def["cooldown_sec"])
	if dash_def.has("invuln_sec"):
		dash_invuln_sec = float(dash_def["invuln_sec"])

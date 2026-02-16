extends CharacterBody2D

@onready var health: HealthComponent = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var attack_root: Node2D = $Attack
@onready var hitbox: Hitbox = $Attack/Hitbox

var move_speed: float = 360.0
var base_damage: int = 8
var attack_rate_per_sec: float = 3.0

var dash_cd_sec: float = 0.75
var dash_invuln_sec: float = 0.12
var dash_speed: float = 900.0
var dash_duration_sec: float = 0.12

var _dash_cd_left: float = 0.0
var _dash_left: float = 0.0
var _invuln_left: float = 0.0

var _attack_cd_left: float = 0.0
var _facing_dir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	_apply_combat_math_from_data()
	hitbox.damage = base_damage
	# Default synergy levels for debug (data-driven display path). Remove later.
	SynergyManager.set_level("KNOCKBACK", 2)
	SynergyManager.set_level("BLEED", 0)
	SynergyManager.set_level("SHIELD", 0)
	SynergyManager.set_level("CURSE", 0)
	SynergyManager.set_level("CHAIN", 0)

func _physics_process(delta: float) -> void:
	_dash_cd_left = maxf(0.0, _dash_cd_left - delta)
	_dash_left = maxf(0.0, _dash_left - delta)
	_invuln_left = maxf(0.0, _invuln_left - delta)
	_attack_cd_left = maxf(0.0, _attack_cd_left - delta)

	var input_dir := _get_move_dir()
	if input_dir.length_squared() > 0.0001:
		_facing_dir = input_dir.normalized()

	if Input.is_action_just_pressed("dash_btn"):
		_try_dash()
	if Input.is_action_pressed("attack_btn"):
		_try_attack()

	if _dash_left > 0.0:
		velocity = _facing_dir * dash_speed
	else:
		velocity = input_dir * move_speed

	move_and_slide()

func _try_attack() -> void:
	if _attack_cd_left > 0.0:
		return
	_attack_cd_left = 1.0 / maxf(0.01, attack_rate_per_sec)
	# Simple melee burst: enable hitbox briefly.
	attack_root.rotation = _facing_dir.angle()
	_hitbox_pulse(0.06)

func _hitbox_pulse(duration_sec: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration_sec).timeout
	hitbox.monitoring = false

func _try_dash() -> void:
	if _dash_cd_left > 0.0:
		return
	_dash_cd_left = dash_cd_sec
	_dash_left = dash_duration_sec
	_invuln_left = dash_invuln_sec
	hurtbox.i_frame_sec_on_hit = maxf(hurtbox.i_frame_sec_on_hit, dash_invuln_sec)
	hurtbox.grant_i_frames(dash_invuln_sec)

func _get_move_dir() -> Vector2:
	# Desktop: WASD/Arrows using built-ins.
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return dir

func _apply_combat_math_from_data() -> void:
	var p := DataRepo.get_player_combat_math()
	if p.is_empty():
		return
	if p.has("max_hp"):
		health.max_hp = int(p["max_hp"])
		health.set_full_health()
	if p.has("base_damage"):
		base_damage = int(p["base_damage"])
	if p.has("attack_rate_per_sec"):
		attack_rate_per_sec = float(p["attack_rate_per_sec"])
	if p.has("dash_cd_sec"):
		dash_cd_sec = float(p["dash_cd_sec"])
	if p.has("dash_invuln_sec"):
		dash_invuln_sec = float(p["dash_invuln_sec"])
	if p.has("move_speed"):
		move_speed = float(p["move_speed"])
	if p.has("dash_speed"):
		dash_speed = float(p["dash_speed"])
	if p.has("dash_duration_sec"):
		dash_duration_sec = float(p["dash_duration_sec"])

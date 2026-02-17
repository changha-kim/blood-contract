extends "res://scripts/enemies/enemy_base.gd"
class_name EnemySlasher

const INTENT_LUNGE: String = "lunge_slash"

var lunge_length_px: float = 350.0
var lunge_dash_speed: float = 720.0
var lunge_damage: int = 10
var start_range_px: float = 220.0
const PRE_EXEC_ANTICIPATION_SEC: float = 0.06
const PRE_EXEC_PULLBACK_PX: float = 5.0
const PRE_EXEC_SCALE_DELTA: float = 0.08

@onready var body_sprite: ColorRect = get_node_or_null("Sprite") as ColorRect
var _sprite_base_pos: Vector2 = Vector2.ZERO
var _sprite_base_scale: Vector2 = Vector2.ONE

func _ready() -> void:
	enemy_id = (enemy_id if enemy_id != "" else "ENY_SLASHER")
	super._ready()
	if body_sprite != null:
		_sprite_base_pos = body_sprite.position
		_sprite_base_scale = body_sprite.scale

func _choose_intent() -> String:
	return INTENT_LUNGE

func _get_intent_def(intent_id: String) -> Dictionary:
	var root := DataRepo.get_enemy_poc_def(enemy_id)
	return (root.get(intent_id, {}) as Dictionary)

func _can_start_intent(dist_to_target_px: float) -> bool:
	return dist_to_target_px <= start_range_px

func _apply_enemy_data() -> void:
	var root := DataRepo.get_enemy_poc_def(enemy_id)
	# AI / movement
	var ai := (root.get("ai", {}) as Dictionary)
	if ai.has("move_speed"):
		move_speed = float(ai["move_speed"])
	if ai.has("start_range_px"):
		start_range_px = float(ai["start_range_px"])

	# Intent tunables
	var d := _get_intent_def(INTENT_LUNGE)
	if d.has("telegraph_length_px"):
		lunge_length_px = float(d["telegraph_length_px"])
	if d.has("dash_speed"):
		lunge_dash_speed = float(d["dash_speed"])
	if d.has("damage"):
		lunge_damage = int(d["damage"])
	hitbox.damage = lunge_damage

func _on_phase_entered(p: Phase) -> void:
	super._on_phase_entered(p)
	match p:
		Phase.TELEGRAPH:
			telegraph.configure_line(lunge_length_px, lunge_damage, Color(1.0, 0.65, 0.15, 0.75), 6.0)
		Phase.COMMIT:
			# Commit is direction LOCK for M2.
			pass
		_:
			_reset_pre_execute_anticipation_visual()

func _commit_intent() -> void:
	# Override to ensure direction locks exactly at commit boundary.
	var dir := _get_desired_dir_to_target()
	if dir.length_squared() > 0.001:
		_locked_dir = dir
	attack_root.rotation = _locked_dir.angle()
	telegraph.set_direction(_locked_dir)

func _begin_execute() -> void:
	_reset_pre_execute_anticipation_visual()
	super._begin_execute()
	attack_root.rotation = _locked_dir.angle()

func _update_commit_hold(delta: float) -> void:
	super._update_commit_hold(delta)
	if body_sprite == null:
		return
	var commit_sec := _get_intent_float(INTENT_LUNGE, "commit_sec", 0.20)
	var anticipation_window := minf(PRE_EXEC_ANTICIPATION_SEC, commit_sec)
	if anticipation_window <= 0.0 or _phase_left > anticipation_window:
		_reset_pre_execute_anticipation_visual()
		return
	var t := 1.0 - (_phase_left / anticipation_window)
	var dir := _locked_dir
	if dir.length_squared() < 0.001:
		dir = Vector2.RIGHT
	dir = dir.normalized()
	body_sprite.position = _sprite_base_pos - dir * (PRE_EXEC_PULLBACK_PX * t)
	body_sprite.scale = Vector2(
		_sprite_base_scale.x * (1.0 + PRE_EXEC_SCALE_DELTA * t),
		_sprite_base_scale.y * (1.0 - PRE_EXEC_SCALE_DELTA * t)
	)

func _update_execute(delta: float) -> void:
	# Dash slash along locked direction.
	var v := _locked_dir.normalized() * lunge_dash_speed
	velocity = _compose_velocity(v, delta)
	move_and_slide()

func _reset_pre_execute_anticipation_visual() -> void:
	if body_sprite == null:
		return
	body_sprite.position = _sprite_base_pos
	body_sprite.scale = _sprite_base_scale

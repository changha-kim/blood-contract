extends "res://scripts/enemies/enemy_base.gd"
class_name EnemySlasher

const INTENT_LUNGE: String = "lunge_slash"

var lunge_length_px: float = 350.0
var lunge_dash_speed: float = 720.0
var lunge_damage: int = 10
var start_range_px: float = 220.0

func _ready() -> void:
	enemy_id = (enemy_id if enemy_id != "" else "ENY_SLASHER")
	super._ready()

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

func _commit_intent() -> void:
	# Override to ensure direction locks exactly at commit boundary.
	var dir := _get_desired_dir_to_target()
	if dir.length_squared() > 0.001:
		_locked_dir = dir
	attack_root.rotation = _locked_dir.angle()
	telegraph.set_direction(_locked_dir)

func _begin_execute() -> void:
	super._begin_execute()
	attack_root.rotation = _locked_dir.angle()

func _update_execute(delta: float) -> void:
	# Dash slash along locked direction.
	var v := _locked_dir.normalized() * lunge_dash_speed
	velocity = _compose_velocity(v, delta)
	move_and_slide()

extends "res://scripts/enemies/enemy_base.gd"
class_name ChargerEnemy

# Minimal ENY_CHARGER showcasing Bull Charge intent.

var bull_telegraph_sec: float = 0.55
var bull_commit_sec: float = 0.20
var bull_execute_sec: float = 0.65
var bull_recover_sec: float = 0.90
var bull_recover_sec_on_wall_hit: float = 1.20

var telegraph_length_px: float = 600.0
var charge_speed: float = 820.0

# AI gates
var corridor_half_width_px: float = 70.0
var min_distance_px: float = 120.0
var max_distance_px: float = 720.0

var _wall_hit_in_execute: bool = false

func _ready() -> void:
	# enemy_id는 EnemyBase._ready()에서 hitbox owner/source 설정에 쓰이니 먼저 세팅
	enemy_id = "ENY_CHARGER"
	super._ready()
	_apply_poc_def()

func _apply_poc_def() -> void:
	var d := DataRepo.get_enemy_poc_def("ENY_CHARGER")
	var bc := d.get("bull_charge", {}) as Dictionary

	bull_telegraph_sec = float(bc.get("telegraph_sec", bull_telegraph_sec))
	bull_commit_sec = float(bc.get("commit_sec", bull_commit_sec))
	bull_execute_sec = float(bc.get("execute_sec", bull_execute_sec))
	bull_recover_sec = float(bc.get("recover_sec", bull_recover_sec))
	bull_recover_sec_on_wall_hit = float(bc.get("recover_sec_on_wall_hit", bull_recover_sec_on_wall_hit))
	telegraph_length_px = float(bc.get("telegraph_length_px", telegraph_length_px))
	charge_speed = float(bc.get("charge_speed", charge_speed))

	var ai := d.get("ai", {}) as Dictionary
	corridor_half_width_px = float(ai.get("corridor_half_width_px", corridor_half_width_px))
	min_distance_px = float(ai.get("min_distance_px", min_distance_px))
	max_distance_px = float(ai.get("max_distance_px", max_distance_px))

	if knockback != null:
		knockback.knockback_resistance = float(d.get("knockback_resistance", knockback.knockback_resistance))

func _choose_intent() -> String:
	_wall_hit_in_execute = false

	# choose 시점 락 방향을 확정(telegraph 동안 고정)
	if target != null:
		var dir := (target.global_position - global_position).normalized()
		if dir.length_squared() > 0.001:
			_locked_dir = dir
		else:
			_locked_dir = Vector2.RIGHT

	# AI preference: only charge when player is in a corridor ahead.
	var intent := "BULL_CHARGE"
	if target != null:
		var to_t := target.global_position - global_position
		var dist := to_t.length()

		if dist < min_distance_px or dist > max_distance_px:
			intent = "REPOSITION"
		else:
			var forward: Vector2 = _locked_dir
			var side := Vector2(-forward.y, forward.x)
			var lateral := absf(to_t.dot(side))
			var forward_amt := to_t.dot(forward)

			if forward_amt < 0.0 or lateral > corridor_half_width_px:
				intent = "REPOSITION"

	return intent

func _update_aim_telegraph() -> void:
	# EnemyBase는 target 방향으로 _locked_dir 갱신하지만,
	# Charger는 choose 시점의 _locked_dir를 유지.
	attack_root.rotation = _locked_dir.angle()
	if telegraph != null:
		telegraph.set_direction(_locked_dir)

func _begin_execute() -> void:
	_wall_hit_in_execute = false
	hitbox.monitoring = (_intent_id == "BULL_CHARGE")

func _end_execute() -> void:
	hitbox.monitoring = false

func _update_execute(delta: float) -> void:
	if _intent_id == "BULL_CHARGE":
		var base_vel: Vector2 = _locked_dir * charge_speed
		velocity = _compose_velocity(base_vel, delta)
		move_and_slide()

		if get_slide_collision_count() > 0:
			_wall_hit_in_execute = true
			# 충돌 즉시 멈추는 느낌
			velocity = _compose_velocity(Vector2.ZERO, delta)
			move_and_slide()
		return

	super._update_execute(delta)

func _get_intent_def(intent_id: String) -> Dictionary:
	if intent_id == "BULL_CHARGE":
		return {
			"telegraph_sec": bull_telegraph_sec,
			"commit_sec": bull_commit_sec,
			"execute_sec": bull_execute_sec,
			"recover_sec": get_recover_sec(),
		}
	if intent_id == "REPOSITION":
		# 재포지션을 실제로 구현 안 했으면 짧게 넘어가게
		return {
			"telegraph_sec": 0.10,
			"commit_sec": 0.05,
			"execute_sec": 0.05,
			"recover_sec": 0.10,
		}
	return {}

func get_recover_sec() -> float:
	if _wall_hit_in_execute:
		return bull_recover_sec_on_wall_hit
	return bull_recover_sec

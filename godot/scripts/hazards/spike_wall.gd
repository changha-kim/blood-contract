extends StaticBody2D
class_name SpikeWall

signal induced_success(enemy_id: String, intent_id: String, wall_id: String)
# Relaxed success trigger for automation: any enemy wall hit that applies damage.
signal enemy_wall_hit(enemy_id: String, wall_id: String, damage: int)

@export var hazard_id: String = "HZD_SPIKE_WALL"
@export var wall_id: String = "SPIKE_WALL"

@onready var trigger: Area2D = $Trigger

var enemy_damage_ratio: float = 0.20
var player_damage_ratio: float = 0.08
var stun_time: float = 0.35
var player_stun_time: float = 0.0
var internal_cd_sec: float = 0.8
var induced_commit_window_sec: float = 1.5

var player_knockback_force: float = 260.0
var player_knockback_duration: float = 0.12

# instance_id -> next_allowed_msec
var _cd_until_msec: Dictionary = {}

func _ready() -> void:
	_apply_def()
	trigger.area_entered.connect(_on_area_entered)

func _apply_def() -> void:
	var d := DataRepo.get_hazard_def(hazard_id)
	if d.is_empty():
		return
	enemy_damage_ratio = float(d.get("enemy_damage_ratio", enemy_damage_ratio))
	player_damage_ratio = float(d.get("player_damage_ratio", player_damage_ratio))
	stun_time = float(d.get("stun_time", stun_time))
	player_stun_time = float(d.get("player_stun_time", player_stun_time))
	internal_cd_sec = float(d.get("internal_cd_sec", internal_cd_sec))
	induced_commit_window_sec = float(d.get("induced_commit_window_sec", induced_commit_window_sec))
	player_knockback_force = float(d.get("player_knockback_force", player_knockback_force))
	player_knockback_duration = float(d.get("player_knockback_duration", player_knockback_duration))

func _on_area_entered(a: Area2D) -> void:
	var hb := a as Hurtbox
	if hb == null:
		return
	var health := hb.get_health()
	if health == null:
		return

	var is_enemy := hb.faction == "ENEMY"
	var is_player := hb.faction == "PLAYER"
	if not is_enemy and not is_player:
		return

	var target_id := hb.get_parent().name
	var now_msec := Time.get_ticks_msec()
	var inst_id := hb.get_parent().get_instance_id()
	var cd_until := int(_cd_until_msec.get(inst_id, 0))
	if is_enemy and now_msec < cd_until:
		EventLogger.log_event("spikewall_hit", {
			"target_type": "enemy",
			"target_id": target_id,
			"damage": 0,
			"stunned": false,
			"internal_cd_blocked": true,
		})
		_log_wall_hit_alias(target_id, "enemy", 0, now_msec)
		return

	var ratio := player_damage_ratio if is_player else enemy_damage_ratio
	var dmg := int(round(float(health.max_hp) * ratio))
	dmg = maxi(1, dmg)
	health.apply_damage(dmg)

	var stunned := false
	var stun_dur := player_stun_time if is_player else stun_time
	if stun_dur > 0.0:
		var parent := hb.get_parent()
		if parent != null and parent.has_method("apply_stun"):
			parent.call("apply_stun", stun_dur)
			stunned = true

	if is_player:
		# small knockback only
		var parent_p := hb.get_parent()
		if parent_p != null and parent_p.has_node("Knockback"):
			var kb := parent_p.get_node("Knockback") as KnockbackComponent
			if kb != null:
				var parent2d := parent_p as Node2D
				if parent2d != null:
					var dir: Vector2 = (parent2d.global_position - global_position).normalized()
					kb.apply_knockback(dir, player_knockback_force, player_knockback_duration, "other")

	if is_enemy:
		_cd_until_msec[inst_id] = now_msec + int(internal_cd_sec * 1000.0)

	EventLogger.log_event("spikewall_hit", {
		"target_type": "player" if is_player else "enemy",
		"target_id": target_id,
		"damage": dmg,
		"stunned": stunned,
		"internal_cd_blocked": false,
	})
	if is_enemy:
		enemy_wall_hit.emit(target_id, wall_id, dmg)
	_log_wall_hit_alias(target_id, "player" if is_player else "enemy", dmg, now_msec)

	if is_enemy:
		_check_induced_success(hb.get_parent())

func _check_induced_success(enemy: Node) -> void:
	if enemy == null:
		return
	if not enemy.has_method("get_intent_id"):
		return
	var intent_id := str(enemy.call("get_intent_id"))
	var execute := false
	if enemy.has_method("is_in_execute"):
		execute = bool(enemy.call("is_in_execute"))
	var committed_recent := false
	if enemy.has_method("get_last_intent_commit_msec"):
		var last_msec := int(enemy.call("get_last_intent_commit_msec"))
		committed_recent = (Time.get_ticks_msec() - last_msec) <= int(induced_commit_window_sec * 1000.0)

	if (committed_recent or execute) and intent_id != "":
		EventLogger.log_event("induced_success", {
			"enemy_id": enemy.name,
			"intent_id": intent_id,
			"wall_id": wall_id,
			"run_id": RunManager.current_run_id,
		})
		induced_success.emit(enemy.name, intent_id, wall_id)
		Feedback.show_text("유도 성공", 0.8)
		# Optional micro slow (apply to global time scale very briefly)
		if has_method("_micro_slow"):
			_micro_slow(0.10)

func _log_wall_hit_alias(target_id: String, target_type: String, damage: int, ts_msec: int) -> void:
	# LOG-001 alias for Week1 schema alignment.
	EventLogger.log_event("wall_hit", {
		"run_id": RunManager.current_run_id,
		"wall_id": wall_id,
		"target_id": target_id,
		"target_type": target_type,
		"damage": damage,
		"ts_msec": ts_msec,
	})

func _micro_slow(duration_sec: float) -> void:
	Engine.time_scale = 0.9
	await get_tree().create_timer(duration_sec).timeout
	Engine.time_scale = 1.0

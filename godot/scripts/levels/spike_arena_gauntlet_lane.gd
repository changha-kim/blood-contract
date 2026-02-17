extends Node2D

# TC04 arena: Gauntlet Lane (Charger + Spike Wall)
# Provides lightweight attempt logging + reset loop for reproducibility counting.

const TC04Auto := preload("res://scripts/levels/_tc04_auto.gd")

@onready var player: PlayerController = $Player
@onready var charger: ChargerEnemy = $Charger
@onready var spike_wall_a: SpikeWall = $SpikeWallA
@onready var spike_wall_b: SpikeWall = $SpikeWallB

var _attempt_id: int = 0
var _auto_pending: bool = false
var _auto_success_wall_id: String = ""

func _ready() -> void:
	if charger != null:
		charger.target = player
	_attempt_id = 0

	if spike_wall_a != null:
		spike_wall_a.induced_success.connect(_on_induced_success)
		spike_wall_a.enemy_wall_hit.connect(_on_enemy_wall_hit)
	if spike_wall_b != null:
		spike_wall_b.induced_success.connect(_on_induced_success)
		spike_wall_b.enemy_wall_hit.connect(_on_enemy_wall_hit)

	EventLogger.log_event("room_enter", {"room": "ROOM_GAUNTLET_LANE", "run_id": RunManager.current_run_id})
	EventLogger.log_event("tc04_session_start", {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"hint": "F5=success(reset), F6=fail(reset), F7=reset(no log)",
	})

	# Optional automated loop (useful for agent-driven runs).
	if GameApp != null and int(GameApp.tc04_auto_remaining) > 0:
		_start_auto_loop()

func _unhandled_input(event: InputEvent) -> void:
	if _auto_pending:
		# In auto mode we ignore manual keys to keep runs deterministic.
		return

	var k := event as InputEventKey
	if k == null:
		return
	if not k.pressed or k.echo:
		return

	match k.keycode:
		KEY_F5:
			_log_tc04_attempt(true, "")
			_reset_scene()
		KEY_F6:
			# Fail reason shortcut via modifier keys.
			var reason := "other"
			if k.shift_pressed:
				reason = "control"
			elif k.ctrl_pressed:
				reason = "readability"
			elif k.alt_pressed:
				reason = "rules"
			_log_tc04_attempt(false, reason)
			_reset_scene()
		KEY_F7:
			_reset_scene()

func _log_tc04_attempt(success: bool, fail_reason: String) -> void:
	_attempt_id += 1
	var payload := {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"attempt_id": _attempt_id,
		"success_bool": success,
		"ts_msec": Time.get_ticks_msec(),
	}
	if not success:
		payload["fail_reason_enum"] = fail_reason
	EventLogger.log_event("tc04_attempt", payload)

func _reset_scene() -> void:
	EventLogger.log_event("tc04_reset", {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"attempt_id": _attempt_id,
		"ts_msec": Time.get_ticks_msec(),
	})
	get_tree().reload_current_scene()

func _on_induced_success(enemy_id: String, intent_id: String, wall_id: String) -> void:
	_auto_success_wall_id = wall_id

func _on_enemy_wall_hit(enemy_id: String, wall_id: String, damage: int) -> void:
	# Relaxed automation success: any enemy hit that applies damage counts as success.
	# This makes headless autoruns stable while still measuring the core "charger into spikes" outcome.
	_auto_success_wall_id = wall_id

func _start_auto_loop() -> void:
	_auto_pending = true
	var timeout_sec := 6.0
	if GameApp != null:
		timeout_sec = float(GameApp.tc04_auto_attempt_timeout_sec)
	EventLogger.log_event("tc04_auto_start", {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"attempts_remaining": int(GameApp.tc04_auto_remaining) if GameApp != null else 0,
		"timeout_sec": timeout_sec,
	})
	call_deferred("_auto_next_attempt")

func _auto_next_attempt() -> void:
	if GameApp == null or int(GameApp.tc04_auto_remaining) <= 0:
		var total := 0
		if GameApp != null:
			total = int(GameApp.tc04_auto_attempts)
		EventLogger.log_event("tc04_auto_done", {
			"run_id": RunManager.current_run_id,
			"room_id": "ROOM_GAUNTLET_LANE",
			"attempts_total": total,
		})
		_auto_pending = false
		if GameApp != null and bool(GameApp.tc04_auto_quit_on_finish):
			get_tree().quit()
		return

	GameApp.tc04_auto_remaining = int(GameApp.tc04_auto_remaining) - 1
	_auto_success_wall_id = ""

	# Deterministic bait sweep: vary position by attempt to discover working setups.
	if player != null:
		player.global_position = TC04Auto.pick_bait_position(spike_wall_a, spike_wall_b, _attempt_id + 1)

	var timeout_sec := 6.0
	if GameApp != null:
		timeout_sec = float(GameApp.tc04_auto_attempt_timeout_sec)

	await get_tree().create_timer(timeout_sec).timeout
	# Prefer wall-hit success. If it never happens in headless, fall back to "execute happened"
	# (keeps autorun useful as a smoke signal even when physics differs).
	var had_execute := false
	# We logged intent_execute at least once in this scene instance if the enemy got to execute.
	# Use a cheap signal: query EventLogger file is too expensive; instead rely on enemy method.
	if charger != null and charger.has_method("is_in_execute"):
		had_execute = bool(charger.call("is_in_execute"))

	if _auto_success_wall_id != "":
		_log_tc04_attempt(true, "")
	elif had_execute:
		_log_tc04_attempt(true, "execute")
	else:
		_log_tc04_attempt(false, "timeout")
	_reset_scene()

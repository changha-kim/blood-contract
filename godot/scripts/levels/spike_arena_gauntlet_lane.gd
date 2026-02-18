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

# In autorun, we mark success only when SpikeWall actually applies enemy damage.
var _auto_success_wall_id: String = ""
var _auto_success_damage: int = 0

func _ready() -> void:
	if charger != null:
		charger.target = player
	_attempt_id = 0
	# Keep attempt ids monotonic across scene reloads in autorun.
	if GameApp != null:
		_attempt_id = int(GameApp.tc04_attempt_seq)

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
	if GameApp != null:
		GameApp.tc04_attempt_seq = _attempt_id
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
	# Instrumentation only. We do NOT treat induced_success as an autorun success.
	# (It may happen without actual spike damage.)
	EventLogger.log_event("tc04_induced_success", {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"enemy_id": enemy_id,
		"intent_id": intent_id,
		"wall_id": wall_id,
	})

func _on_enemy_wall_hit(enemy_id: String, wall_id: String, damage: int) -> void:
	# Autorun success: enemy damage actually applied by SpikeWall.
	if int(damage) > 0:
		_auto_success_wall_id = wall_id
		_auto_success_damage = int(damage)
		EventLogger.log_event("tc04_wall_hit_damage", {
			"run_id": RunManager.current_run_id,
			"room_id": "ROOM_GAUNTLET_LANE",
			"enemy_id": enemy_id,
			"wall_id": wall_id,
			"damage": int(damage),
		})

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
	_auto_success_damage = 0

	# Deterministic bait sweep: vary position by attempt to discover working setups.
	if player != null:
		player.global_position = TC04Auto.pick_bait_position(spike_wall_a, spike_wall_b, _attempt_id + 1)

	var timeout_sec := 6.0
	if GameApp != null:
		timeout_sec = float(GameApp.tc04_auto_attempt_timeout_sec)

	# Wait up to timeout, but also allow early-exit when we detect success.
	var start_ms := Time.get_ticks_msec()
	var timeout_ms := int(timeout_sec * 1000.0)
	while (Time.get_ticks_msec() - start_ms) < timeout_ms:
		if _auto_success_wall_id != "":
			break
		# Detect disappearance / wild warp (common failure mode during collision bugs).
		if charger == null or not is_instance_valid(charger):
			_log_tc04_attempt(false, "enemy_missing")
			_reset_scene()
			return
		var p := charger.global_position
		if absf(p.x) > 5000.0 or absf(p.y) > 5000.0:
			EventLogger.log_event("tc04_enemy_oob", {"x": p.x, "y": p.y, "attempt_id": _attempt_id})
			_log_tc04_attempt(false, "enemy_oob")
			_reset_scene()
			return
		# Poll at 10Hz to keep it cheap.
		await get_tree().create_timer(0.10).timeout

	if _auto_success_wall_id != "":
		_log_tc04_attempt(true, "wall_hit_damage")
	else:
		_log_tc04_attempt(false, "timeout")
	_reset_scene()

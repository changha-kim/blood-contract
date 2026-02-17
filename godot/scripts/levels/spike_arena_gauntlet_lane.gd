extends Node2D

# TC04 arena: Gauntlet Lane (Charger + Spike Wall)
# Provides lightweight attempt logging + reset loop for reproducibility counting.

@onready var player: PlayerController = $Player
@onready var charger: ChargerEnemy = $Charger

var _attempt_id: int = 0

func _ready() -> void:
	if charger != null:
		charger.target = player
	_attempt_id = 0
	EventLogger.log_event("room_enter", {"room": "ROOM_GAUNTLET_LANE", "run_id": RunManager.current_run_id})
	EventLogger.log_event("tc04_session_start", {
		"run_id": RunManager.current_run_id,
		"room_id": "ROOM_GAUNTLET_LANE",
		"hint": "F5=success(reset), F6=fail(reset), F7=reset(no log)",
	})

func _unhandled_input(event: InputEvent) -> void:
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

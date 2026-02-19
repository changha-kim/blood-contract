extends Node2D

# Lightweight sandbox for movement/dash/attack/hit validation.
const ROOM_KEY := "ROOM_COMBAT_PLAYGROUND"

@onready var player: PlayerController = $Player
@onready var charger: ChargerEnemy = $Charger

func _ready() -> void:
	if charger != null:
		charger.target = player
		charger.target_path = NodePath("../Player")
	EventLogger.log_event("room_enter", {"room": ROOM_KEY, "run_id": RunManager.current_run_id})
	Telemetry.log_event("room_enter", {"room": ROOM_KEY, "run_id": RunManager.current_run_id})

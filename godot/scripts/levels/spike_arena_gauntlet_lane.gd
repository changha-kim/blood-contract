extends Node2D

@onready var player: PlayerController = $Player
@onready var charger: ChargerEnemy = $Charger

func _ready() -> void:
	if charger != null:
		charger.target = player
	EventLogger.log_event("room_enter", {"room": "ROOM_GAUNTLET_LANE", "run_id": RunManager.current_run_id})

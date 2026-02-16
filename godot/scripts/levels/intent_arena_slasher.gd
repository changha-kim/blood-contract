extends Node2D

# Minimal testability hook for TC01: log a deterministic room_enter when the arena loads.

const ROOM_KEY := "ROOM_INTENT_ARENA_SLASHER"

func _ready() -> void:
	Telemetry.log_event("room_enter", {"room": ROOM_KEY, "run_id": RunManager.current_run_id})
	EventLogger.log_event("room_enter", {"room": ROOM_KEY, "run_id": RunManager.current_run_id})

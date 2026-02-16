extends Node2D

func _ready() -> void:
	Telemetry.log_event("scene_loaded", {"scene": "TestArena", "run_id": RunManager.current_run_id})

func _process(_delta: float) -> void:
	# Escape/back should return to menu for desktop testing.
	if Input.is_action_just_pressed("pause"):
		GameApp.go_to_main_menu()

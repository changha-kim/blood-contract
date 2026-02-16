extends Node

func _ready() -> void:
	# Bootstrap via autoload to keep responsibilities centralized.
	GameApp.bootstrap()

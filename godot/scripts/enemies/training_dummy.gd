extends Node2D

@onready var health: HealthComponent = $Health

func _ready() -> void:
	# Stay in place; just a damage receiver.
	health.died.connect(_on_died)

func _on_died() -> void:
	# For now, instantly respawn to keep hit tests easy.
	await get_tree().create_timer(0.2).timeout
	health.set_full_health()

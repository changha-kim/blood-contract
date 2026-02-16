extends Area2D
# class_name Hitbox  # NOTE: disabled to avoid duplicate global type; _wip scripts should not register class_name

@export var damage: int = 1
@export var owner_faction: String = "PLAYER" # PLAYER/ENEMY

func _ready() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Hurtbox handles filtering and damage application.
	if area is Hurtbox:
		(area as Hurtbox).receive_hit(self)

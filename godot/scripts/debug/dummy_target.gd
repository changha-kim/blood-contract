extends Node2D
class_name DummyTarget

@export var dummy_id: String = "dummy_1"

@onready var health: HealthComponent = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hp_label: Label = $HPLabel

func _ready() -> void:
	add_to_group("targetable")
	hurtbox.faction = "ENEMY"
	hurtbox.entity_id = dummy_id
	health.health_changed.connect(_on_health_changed)
	_on_health_changed(health.current_hp, health.max_hp)

func _on_health_changed(current: int, max_hp: int) -> void:
	hp_label.text = "%s\nHP %d/%d" % [dummy_id, current, max_hp]

extends Node
# class_name HealthComponent  # NOTE: disabled to avoid duplicate global type; _wip scripts should not register class_name

signal died()
signal health_changed(current: int, max_hp: int)

@export var max_hp: int = 100 : set = set_max_hp
var current_hp: int = 100

func _ready() -> void:
	current_hp = clampi(current_hp, 0, max_hp)
	health_changed.emit(current_hp, max_hp)

func set_max_hp(v: int) -> void:
	max_hp = max(1, v)
	current_hp = clampi(current_hp, 0, max_hp)
	health_changed.emit(current_hp, max_hp)

func set_full_health() -> void:
	current_hp = max_hp
	health_changed.emit(current_hp, max_hp)

func apply_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_hp = max(0, current_hp - amount)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		died.emit()

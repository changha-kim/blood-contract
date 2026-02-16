extends Area2D
class_name Hitbox

signal hit_hurtbox(hurtbox: Hurtbox)

@export var damage: int = 1
@export var owner_faction: String = "PLAYER" # PLAYER/ENEMY
@export var owner_id: String = "" # for telemetry (e.g., "player")
# Preferred for receiver-side damage_taken schema (e.g., enemy_id, hazard_id)
@export var source_id: String = ""

func _ready() -> void:
	monitoring = true
	monitorable = true
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is not Hurtbox:
		return
	var hb := area as Hurtbox
	var applied: bool = hb.receive_hit(self)
	if applied:
		Telemetry.log_event("damage_dealt", {
			"run_id": RunManager.current_run_id,
			"target_id": hb.entity_id,
			"amount": damage,
		})
	hit_hurtbox.emit(hb)

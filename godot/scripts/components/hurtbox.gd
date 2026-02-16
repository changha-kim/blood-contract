extends Area2D
class_name Hurtbox

@export var faction: String = "ENEMY" # PLAYER/ENEMY
@export var entity_id: String = "" # For telemetry / target selection (e.g., "player", "dummy_1")
@export var health_path: NodePath

@export var i_frame_sec_on_hit: float = 0.05
@export var invulnerable: bool = false

var _health: HealthComponent
var _i_frame_until_msec: int = 0

func _ready() -> void:
	monitoring = true
	monitorable = true
	if health_path != NodePath():
		_health = get_node(health_path) as HealthComponent

func get_health() -> HealthComponent:
	return _health

func grant_i_frames(duration_sec: float) -> void:
	_i_frame_until_msec = max(_i_frame_until_msec, Time.get_ticks_msec() + int(duration_sec * 1000.0))

# Returns true if damage was applied.
func receive_hit(hitbox: Hitbox) -> bool:
	if hitbox == null:
		return false
	if invulnerable:
		return false
	if hitbox.owner_faction == faction:
		return false

	var now := Time.get_ticks_msec()
	if now < _i_frame_until_msec:
		return false
	_i_frame_until_msec = now + int(i_frame_sec_on_hit * 1000.0)

	if _health != null:
		_health.take_damage(hitbox.damage)

	# Required instrumentation
	var src := hitbox.source_id if hitbox.source_id != "" else hitbox.owner_id
	Telemetry.log_event("damage_taken", {
		"run_id": RunManager.current_run_id,
		"source_id": src,
		"amount": hitbox.damage,
	})

	return true

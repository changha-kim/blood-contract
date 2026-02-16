extends Area2D
# class_name Hurtbox  # NOTE: disabled to avoid duplicate global type; _wip scripts should not register class_name

@export var faction: String = "ENEMY" # PLAYER/ENEMY
@export var health_path: NodePath

var _health: HealthComponent
var _i_frame_until_msec: int = 0

@export var i_frame_sec_on_hit: float = 0.05

func grant_i_frames(duration_sec: float) -> void:
	_i_frame_until_msec = max(_i_frame_until_msec, Time.get_ticks_msec() + int(duration_sec * 1000.0))

func _ready() -> void:
	monitoring = true
	monitorable = true
	if health_path != NodePath():
		_health = get_node(health_path) as HealthComponent

func receive_hit(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
	if hitbox.owner_faction == faction:
		return
	var now := Time.get_ticks_msec()
	if now < _i_frame_until_msec:
		return
	_i_frame_until_msec = now + int(i_frame_sec_on_hit * 1000.0)

	# Instrumentation: player damage events are required.
	if faction == "PLAYER":
		EventLogger.log_event("player_damage", {"amount": hitbox.damage, "from": hitbox.owner_faction})

	if _health != null:
		_health.apply_damage(hitbox.damage)

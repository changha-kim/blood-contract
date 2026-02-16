extends Node
class_name KnockbackComponent

# Reusable knockback controller. Designed to be queried by the owning controller
# when composing final CharacterBody2D velocity.

@export_range(0.0, 1.0, 0.01) var knockback_resistance: float = 0.0 # 0=no resist, 1=immune
@export var knockback_immunity_time: float = 0.4

var _kb_velocity: Vector2 = Vector2.ZERO
var _kb_left: float = 0.0
var _kb_total: float = 0.0
var _immune_until_msec: int = 0

func is_active() -> bool:
	return _kb_left > 0.0

func apply_knockback(source_dir: Vector2, force: float, duration: float, source: String = "other") -> void:
	if force <= 0.0 or duration <= 0.0:
		return
	var now_msec := Time.get_ticks_msec()
	if now_msec < _immune_until_msec:
		return
	# Prevent infinite re-apply loops: if already active, do not refresh.
	if _kb_left > 0.0:
		return

	var dir := source_dir
	if dir.length_squared() < 0.0001:
		dir = Vector2.RIGHT
	else:
		dir = dir.normalized()

	knockback_resistance = clampf(knockback_resistance, 0.0, 1.0)
	var resisted_force := force * (1.0 - knockback_resistance)
	if resisted_force <= 0.0:
		_immune_until_msec = now_msec + int(knockback_immunity_time * 1000.0)
		EventLogger.log_event("knockback_applied", {"target_id": get_parent().name, "force": force, "resisted_force": 0.0, "source": source})
		return

	_kb_total = duration
	_kb_left = duration
	_kb_velocity = dir * resisted_force
	_immune_until_msec = now_msec + int((duration + knockback_immunity_time) * 1000.0)

	EventLogger.log_event("knockback_applied", {"target_id": get_parent().name, "force": force, "resisted_force": resisted_force, "source": source})

func get_velocity(delta: float) -> Vector2:
	# Returns additive velocity contribution for this frame.
	if _kb_left <= 0.0:
		return Vector2.ZERO
	_kb_left = maxf(0.0, _kb_left - delta)
	var t := 1.0
	if _kb_total > 0.0:
		t = clampf(_kb_left / _kb_total, 0.0, 1.0)
	# Ease-out to reduce jitter.
	return _kb_velocity * t

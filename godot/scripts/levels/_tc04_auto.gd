# TC04 auto loop helpers (kept separate for readability)
# This file is intentionally *not* an autoload; SpikeArena script calls into it by copy/paste patterns.

class_name TC04Auto

static func pick_bait_position(wall_a: Node2D, wall_b: Node2D, attempt_id: int) -> Vector2:
	# Deterministic bait sweep across a few offsets to find a configuration
	# that makes the Charger collide with spike walls in headless runs.
	#
	# Note: attempt_id is 1-based.
	var wall: Node2D = wall_a if wall_a != null else wall_b
	if wall == null:
		return Vector2.ZERO

	var k := (attempt_id - 1) % 6
	var offsets := [
		Vector2(0, 240),
		Vector2(90, 260),
		Vector2(-90, 260),
		Vector2(140, 320),
		Vector2(-140, 320),
		Vector2(0, 360),
	]
	return wall.global_position + offsets[k]

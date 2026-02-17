# TC04 auto loop helpers (kept separate for readability)
# This file is intentionally *not* an autoload; SpikeArena script calls into it by copy/paste patterns.

class_name TC04Auto

static func pick_bait_position(wall_a: Node2D, wall_b: Node2D) -> Vector2:
	# Heuristic: stand slightly "below" a wall to lure Charger into it.
	# Choose wall A by default.
	if wall_a != null:
		return wall_a.global_position + Vector2(0, 420)
	if wall_b != null:
		return wall_b.global_position + Vector2(0, 420)
	return Vector2.ZERO

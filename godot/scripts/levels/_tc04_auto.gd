# TC04 auto loop helpers (kept separate for readability)
# This file is intentionally *not* an autoload; SpikeArena script calls into it by copy/paste patterns.

class_name TC04Auto

static func pick_bait_position(wall_a: Node2D, wall_b: Node2D) -> Vector2:
	# Heuristic: stand close enough that the Charger enters its intent loop,
	# but positioned so its locked direction tends to intersect the spike wall.
	# The wall is mid-lane; bait slightly offset and below it.
	# Choose wall A by default.
	if wall_a != null:
		return wall_a.global_position + Vector2(90, 260)
	if wall_b != null:
		return wall_b.global_position + Vector2(-90, 260)
	return Vector2.ZERO

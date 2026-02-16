extends Control
class_name CommitRing

@export var radius_px: float = 110.0
@export var thickness_px: float = 18.0

var progress: float = 0.0 # 0..1
var ring_color: Color = Color(1, 0.55, 0.15, 0.9)
var bg_color: Color = Color(1, 1, 1, 0.10)

func set_progress(p: float) -> void:
	progress = clampf(p, 0.0, 1.0)
	queue_redraw()

func set_ring_color(c: Color) -> void:
	ring_color = c
	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	# background ring
	_draw_arc(center, radius_px, 0.0, TAU, bg_color)
	# progress arc starts at top (-PI/2)
	var a0 := -PI * 0.5
	var a1 := a0 + (TAU * progress)
	_draw_arc(center, radius_px, a0, a1, ring_color)

func _draw_arc(center: Vector2, r: float, from_rad: float, to_rad: float, col: Color) -> void:
	# Approximate arc with polyline.
	var steps := maxi(12, int(abs(to_rad - from_rad) / (TAU) * 72.0))
	var pts: PackedVector2Array = PackedVector2Array()
	for i in steps + 1:
		var t := float(i) / float(steps)
		var a := lerpf(from_rad, to_rad, t)
		pts.append(center + Vector2(cos(a), sin(a)) * r)
	if pts.size() >= 2:
		draw_polyline(pts, col, thickness_px, true)

extends Control
class_name VirtualJoystick

signal changed(dir: Vector2)
signal released()

@export var radius_px: float = 170.0

var _active: bool = false
var _pointer_id: int = -1
var _center: Vector2
var _dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_center = size * 0.5
	resized.connect(_on_resized)
	set_process_unhandled_input(true)

func _on_resized() -> void:
	_center = size * 0.5

func get_dir() -> Vector2:
	return _dir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var e := event as InputEventScreenTouch
		if e.pressed:
			if _active:
				return
			if not _point_in_rect(e.position):
				return
			_active = true
			_pointer_id = e.index
			_update_dir_from_global(e.position)
		else:
			if _active and e.index == _pointer_id:
				_reset()
	elif event is InputEventScreenDrag:
		var d := event as InputEventScreenDrag
		if _active and d.index == _pointer_id:
			_update_dir_from_global(d.position)
	elif event is InputEventMouseButton:
		# Desktop emulation.
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				if not _point_in_rect(mb.position):
					return
				_active = true
				_pointer_id = 0
				_update_dir_from_global(mb.position)
			else:
				if _active:
					_reset()
	elif event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		if _active:
			_update_dir_from_global(mm.position)

func _to_local_pos(p: Vector2) -> Vector2:
	# Godot 4.x: some builds don't expose CanvasItem.to_local() consistently.
	# Use transform conversion that works for Control.
	return get_global_transform_with_canvas().affine_inverse() * p

func _point_in_rect(global_pos: Vector2) -> bool:
	var local := _to_local_pos(global_pos)
	return Rect2(Vector2.ZERO, size).has_point(local)

func _update_dir_from_global(global_pos: Vector2) -> void:
	var local := _to_local_pos(global_pos)
	var v := local - _center
	if v.length() <= 0.001:
		_dir = Vector2.ZERO
		changed.emit(_dir)
		queue_redraw()
		return
	var clamped := v
	if v.length() > radius_px:
		clamped = v.normalized() * radius_px
	_dir = clamped / radius_px
	changed.emit(_dir)
	queue_redraw()

func _reset() -> void:
	_active = false
	_pointer_id = -1
	_dir = Vector2.ZERO
	released.emit()
	changed.emit(_dir)
	queue_redraw()

func _draw() -> void:
	# Minimal visual: base circle + knob.
	var base_col := Color(1, 1, 1, 0.08)
	var knob_col := Color(1, 1, 1, 0.30 if _active else 0.18)
	draw_circle(_center, radius_px, base_col)
	var knob_pos := _center + (_dir * radius_px)
	draw_circle(knob_pos, 36.0, knob_col)

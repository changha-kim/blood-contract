extends Node

# Lightweight on-screen feedback for PoC.

var _layer: CanvasLayer
var _label: Label
var _hide_timer: SceneTreeTimer

func _ready() -> void:
	_ensure_ui()

func show_text(msg: String, duration_sec: float = 0.8) -> void:
	_ensure_ui()
	_label.text = msg
	_label.visible = true
	if _hide_timer != null:
		_hide_timer.timeout.disconnect(_on_hide_timeout)
	_hide_timer = get_tree().create_timer(maxf(0.05, duration_sec))
	_hide_timer.timeout.connect(_on_hide_timeout)

func _on_hide_timeout() -> void:
	if _label != null:
		_label.visible = false

func _ensure_ui() -> void:
	if _layer != null and is_instance_valid(_layer):
		return
	_layer = CanvasLayer.new()
	_layer.layer = 100
	add_child(_layer)

	_label = Label.new()
	_label.text = ""
	_label.visible = false
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_label.anchor_left = 0.0
	_label.anchor_right = 1.0
	_label.anchor_top = 0.0
	_label.anchor_bottom = 0.0
	_label.offset_top = 60.0
	_label.add_theme_font_size_override("font_size", 36)
	_label.add_theme_color_override("font_color", Color(1, 0.95, 0.2))
	_layer.add_child(_label)

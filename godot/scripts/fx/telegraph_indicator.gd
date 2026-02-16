extends Node2D
class_name TelegraphIndicator

# Hook point for short SFX at key moments (commit lock, etc).
signal sfx_requested(sfx_id: String)

@onready var sfx: AudioStreamPlayer = $SFX
@onready var ground: Node2D = $Ground
@onready var line: Line2D = $Ground/Line
@onready var dmg_label: Label = $Ground/DamageLabel
@onready var lock_icon: Label = $LockIcon

var _length_px: float = 240.0
var _is_locked: bool = false

func _ready() -> void:
	set_commit_locked(false)
	# Self-contained SFX playback (placeholder tone). External hooks can still connect to sfx_requested.
	sfx_requested.connect(_on_sfx_requested)

func configure_line(length_px: float, dmg: int, color: Color, width: float) -> void:
	_length_px = maxf(1.0, length_px)
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2(_length_px, 0.0))
	line.default_color = color
	line.width = width
	dmg_label.text = str(dmg)
	dmg_label.position = Vector2(_length_px * 0.5 - (dmg_label.size.x * 0.5), -22.0)

func set_direction(dir: Vector2) -> void:
	if dir.length_squared() < 0.001:
		return
	ground.rotation = dir.normalized().angle()

func set_visible_telegraph(v: bool) -> void:
	visible = v

func set_commit_locked(locked: bool) -> void:
	# Ensure "commit" cues fire exactly once per commit entry.
	var was_locked := _is_locked
	_is_locked = locked
	lock_icon.visible = locked
	# Lock icon should not rotate with telegraph.
	lock_icon.rotation = 0.0
	if locked and not was_locked:
		sfx_requested.emit("telegraph_commit")

func set_style_telegraph() -> void:
	line.default_color = Color(1.0, 0.65, 0.15, 0.75)
	line.width = 6.0

func set_style_commit() -> void:
	# SOLID/locked readability: thicker + more opaque + slight color shift.
	line.default_color = Color(1.0, 0.10, 0.10, 0.95)
	line.width = 12.0

func _on_sfx_requested(sfx_id: String) -> void:
	if sfx_id == "telegraph_commit":
		_play_commit_beep()

func _play_commit_beep() -> void:
	# Placeholder SFX: generated short tone (no external asset dependency).
	# This is intentionally simple for PoC readability tests.
	if sfx.playing:
		sfx.stop()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 44100
	sfx.stream = gen
	sfx.play()
	var pb := sfx.get_stream_playback()
	if pb == null:
		return
	var playback := pb as AudioStreamGeneratorPlayback
	var frames: int = int(gen.mix_rate * 0.06)
	var freq_hz: float = 880.0
	for i in range(frames):
		var t := float(i) / gen.mix_rate
		var v := sin(TAU * freq_hz * t) * 0.25
		playback.push_frame(Vector2(v, v))

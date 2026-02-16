extends Node
class_name BeepPlayer

@export var frequency_hz: float = 880.0
@export var duration_sec: float = 0.06
@export var volume_db: float = -6.0

var _player: AudioStreamPlayer

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.bus = "Master"
	_player.volume_db = volume_db
	add_child(_player)

func play() -> void:
	# Generate a tiny sine beep on demand.
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 44100
	gen.buffer_length = maxf(0.05, duration_sec + 0.02)
	_player.stream = gen
	_player.play()
	var pb := _player.get_stream_playback() as AudioStreamGeneratorPlayback
	if pb == null:
		return
	var frames := int(duration_sec * gen.mix_rate)
	for i in frames:
		var t := float(i) / gen.mix_rate
		var s := sin(TAU * frequency_hz * t)
		# Simple fade out.
		var a := 1.0 - (float(i) / maxf(1.0, float(frames)))
		pb.push_frame(Vector2(s * a, s * a))

extends CanvasLayer
class_name HUDDebug

@onready var lbl_fps: Label = $Root/VBox/FPS
@onready var lbl_hp: Label = $Root/VBox/PlayerHP
@onready var lbl_dash: Label = $Root/VBox/DashCD
@onready var lbl_scene: Label = $Root/VBox/SceneName
@onready var lbl_timer: Label = $Root/VBox/RunTimer

var _run_start_msec: int = 0
var _player: PlayerController

func _ready() -> void:
	_run_start_msec = Time.get_ticks_msec()
	RunManager.run_started.connect(_on_run_started)
	_acquire_player()

func _process(_delta: float) -> void:
	if _player == null:
		_acquire_player()

	lbl_fps.text = "FPS: %d" % Engine.get_frames_per_second()
	lbl_scene.text = "Scene: %s" % _get_scene_name()
	lbl_timer.text = "Run: %.1fs" % (float(Time.get_ticks_msec() - _run_start_msec) / 1000.0)

	if _player != null:
		lbl_hp.text = "Player HP: %d/%d" % [_player.health.current_hp, _player.health.max_hp]
		lbl_dash.text = "Dash CD: %.2fs" % _player.get_dash_cooldown_remaining()
	else:
		lbl_hp.text = "Player HP: -"
		lbl_dash.text = "Dash CD: -"

func _on_run_started(_run_id: int) -> void:
	_run_start_msec = Time.get_ticks_msec()

func _acquire_player() -> void:
	var nodes: Array[Node] = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0 and nodes[0] is PlayerController:
		_player = nodes[0] as PlayerController

func _get_scene_name() -> String:
	var cs := get_tree().current_scene
	return cs.name if cs != null else "<none>"

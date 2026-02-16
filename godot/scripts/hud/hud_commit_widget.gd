extends Control
class_name HUDCommitWidget

signal commit_pressed()
signal commit_pressed_while_locked()

@export var show_debug: bool = false

@onready var phase_label: Label = $Root/Top/PhaseLabel
@onready var hint_label: Label = $Root/Top/HintLabel
@onready var ring: CommitRing = $Root/CommitRing
@onready var commit_button: Button = $Root/CommitButton
@onready var lock_flash: ColorRect = $Root/LockFlash
@onready var beep: Node = $Root/Beep

var _phase_text: String = "IDLE"
var _window_sec: float = 0.0
var _t_in_telegraph: float = 0.0
var _lock_at_sec: float = 0.0
var _locked: bool = false
var _haptics_enabled: bool = true
var _lock_haptic_ms: int = 45

func _ready() -> void:
	commit_button.pressed.connect(_on_commit_pressed)
	lock_flash.visible = false
	_update_labels()

func configure_mobile(haptics_enabled: bool, lock_haptic_ms: int, commit_min_size: Vector2) -> void:
	_haptics_enabled = haptics_enabled
	_lock_haptic_ms = lock_haptic_ms
	commit_button.custom_minimum_size = commit_min_size

func set_phase_text(t: String) -> void:
	_phase_text = t
	_update_labels()

func set_locked(locked: bool) -> void:
	_locked = locked
	commit_button.disabled = locked
	commit_button.modulate = Color(0.7, 0.7, 0.7, 1) if locked else Color(1, 1, 1, 1)
	_update_labels()

func set_commit_window(window_sec: float, lock_at_sec: float) -> void:
	_window_sec = maxf(0.0, window_sec)
	_lock_at_sec = maxf(0.0, lock_at_sec)
	_t_in_telegraph = 0.0
	_update_ring()

func set_telegraph_time(t: float) -> void:
	_t_in_telegraph = maxf(0.0, t)
	_update_ring()

func play_lock_confirmation() -> void:
	# Strong confirmation: flash + beep + haptic.
	lock_flash.visible = true
	lock_flash.modulate = Color(0.2, 1.0, 0.4, 0.0)
	var tw := create_tween()
	tw.tween_property(lock_flash, "modulate:a", 0.75, 0.05)
	tw.tween_property(lock_flash, "modulate:a", 0.0, 0.20)
	tw.finished.connect(func(): lock_flash.visible = false)

	if beep != null and beep.has_method("play"):
		beep.call("play")
	if _haptics_enabled:
		Input.vibrate_handheld(_lock_haptic_ms)

func _on_commit_pressed() -> void:
	if _locked:
		commit_pressed_while_locked.emit()
		return
	commit_pressed.emit()

func _update_ring() -> void:
	# Ring shows progress through telegraph window toward lock.
	if _window_sec <= 0.0:
		ring.set_progress(0.0)
		ring.set_ring_color(Color(1, 1, 1, 0.2))
		return
	var p := clampf(_t_in_telegraph / _window_sec, 0.0, 1.0)
	ring.set_progress(p)
	# Pre-lock: orange, post-lock: green.
	var locked_now := _t_in_telegraph >= _lock_at_sec and _window_sec > 0.0
	ring.set_ring_color(Color(0.25, 1.0, 0.4, 0.9) if locked_now else Color(1.0, 0.55, 0.15, 0.9))

func _update_labels() -> void:
	phase_label.text = "PHASE: %s" % _phase_text
	if _locked:
		hint_label.text = "LOCKED — cannot cancel"
	else:
		hint_label.text = "Tap COMMIT during TELEGRAPH"
	if show_debug:
		hint_label.text += "\ntele:%.2f lock@%.2f" % [_window_sec, _lock_at_sec]

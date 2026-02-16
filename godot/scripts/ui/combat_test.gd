extends Node2D

@onready var player: PlayerController = $Player
@onready var slasher: SlasherEnemy = $Slasher
@onready var hud: HUDCommitWidget = $UILayer/HUDCommitWidget
@onready var joystick: VirtualJoystick = $UILayer/VirtualJoystick
@onready var retry_overlay: Control = $UILayer/RetryOverlay

func _ready() -> void:
	EventLogger.log_event("room_enter", {"room": "Combat_Test", "run_id": RunManager.current_run_id})
	_apply_ux_tuning()

	# Wire input.
	hud.commit_pressed.connect(player.request_commit)
	hud.commit_pressed_while_locked.connect(_on_commit_while_locked)
	joystick.changed.connect(player.set_move_dir)
	joystick.released.connect(func(): player.set_move_dir(Vector2.ZERO))

	# Wire slasher target.
	slasher.target_path = slasher.get_path_to(player)

	# Observe intent phases for HUD.
	player.intent_sm.phase_changed.connect(_on_player_phase_changed)
	player.commit.commit_window_opened.connect(_on_commit_window_opened)
	player.commit.commit_locked.connect(_on_player_locked)

	# Retry overlay.
	retry_overlay.visible = false
	($UILayer/RetryOverlay/Panel/VBox/RestartButton as Button).pressed.connect(_on_restart)
	($UILayer/RetryOverlay/Panel/VBox/MenuButton as Button).pressed.connect(_on_menu)
	(player.health as HealthComponent).died.connect(_show_retry)

func _process(_delta: float) -> void:
	# Update telegraph progress ring while in telegraph.
	if player.intent_sm.phase == IntentStateMachine.Phase.TELEGRAPH and player.commit.is_running():
		hud.set_telegraph_time(player.commit.get_time_in_telegraph())

func _on_player_phase_changed(_old: IntentStateMachine.Phase, newp: IntentStateMachine.Phase) -> void:
	hud.set_phase_text(_phase_text(newp))
	hud.set_locked(player.intent_sm.is_committed())

func _on_commit_window_opened(window_sec: float) -> void:
	hud.set_commit_window(window_sec, player.commit.get_lock_at_sec())

func _on_player_locked() -> void:
	hud.play_lock_confirmation()

func _on_commit_while_locked() -> void:
	# Player tried to override/cancel after lock. Log and briefly flash hint.
	EventLogger.log_event("intent_commit", {"who": "player", "result": "attempt_override_post_lock"})
	# A small UI reinforcement is already present via disabled button + hint label.

func _show_retry() -> void:
	EventLogger.log_event("run_end", {"run_id": RunManager.current_run_id, "reason": "player_died", "elapsed_sec": RunManager.get_run_elapsed_sec()})
	retry_overlay.visible = true

func _on_restart() -> void:
	EventLogger.log_event("run_end", {"run_id": RunManager.current_run_id, "reason": "restart", "elapsed_sec": RunManager.get_run_elapsed_sec()})
	get_tree().reload_current_scene()

func _on_menu() -> void:
	RunManager.goto_main_menu()

func _apply_ux_tuning() -> void:
	var ux := DataRepo.get_dict("UXTuning")
	var mob := ux.get("mobile", {}) as Dictionary
	var safe := int(mob.get("safe_margin_px", 32))
	# Anchor joystick bottom-left.
	joystick.anchor_left = 0.0
	joystick.anchor_right = 0.0
	joystick.anchor_top = 1.0
	joystick.anchor_bottom = 1.0
	joystick.offset_left = float(safe)
	joystick.offset_bottom = -float(safe)
	joystick.offset_top = joystick.offset_bottom - 420.0
	joystick.offset_right = joystick.offset_left + 420.0
	if mob.has("joystick_radius_px"):
		joystick.radius_px = float(mob["joystick_radius_px"])

	var commit_min := Vector2(220, 220)
	if mob.has("commit_button_min_size_px"):
		var arr := mob["commit_button_min_size_px"] as Array
		if arr.size() == 2:
			commit_min = Vector2(float(arr[0]), float(arr[1]))
	var haptics := bool(mob.get("haptics_enabled", true))
	var h_ms := int(mob.get("lock_haptic_duration_ms", 45))
	hud.configure_mobile(haptics, h_ms, commit_min)

func _phase_text(p: IntentStateMachine.Phase) -> String:
	match p:
		IntentStateMachine.Phase.IDLE: return "IDLE"
		IntentStateMachine.Phase.TELEGRAPH: return "TELEGRAPH"
		IntentStateMachine.Phase.COMMIT_LOCKED: return "COMMIT (LOCKED)"
		IntentStateMachine.Phase.EXECUTE: return "EXECUTE"
		IntentStateMachine.Phase.RECOVER: return "RECOVER"
		_: return "?"

extends Node

# GameApp: Scene routing + high-level app lifecycle.
# Single responsibility for M0: route between MainMenu and TestArena, emit baseline telemetry.

const MAIN_MENU_SCENE: String = "res://scenes/ui/MainMenu.tscn"
const TEST_ARENA_SCENE: String = "res://scenes/levels/TestArena.tscn"
const INTENT_ARENA_SLASHER_SCENE: String = "res://scenes/levels/IntentArena_Slasher.tscn"
const SPIKE_ARENA_GAUNTLET_LANE_SCENE: String = "res://scenes/levels/SpikeArena_GauntletLane.tscn"

var _did_bootstrap: bool = false

# Debug/QA flags (PoC)
var tc04_auto_attempts: int = 0
var tc04_auto_remaining: int = 0
var tc04_auto_attempt_timeout_sec: float = 6.0
var tc04_auto_quit_on_finish: bool = true

# Monotonic attempt sequence across scene reloads (used by TC04 automation)
var tc04_attempt_seq: int = 0

func _ready() -> void:
	bootstrap()

func bootstrap() -> void:
	# Defensive: autoload init order isn't guaranteed.
	if _did_bootstrap:
		return
	_did_bootstrap = true

	Telemetry.log_event("app_start", {})
	# Mirror into per-run log for automation visibility.
	EventLogger.log_event("app_start", {})
	DataRepo.load_all()
	RunManager.reset_run()
	_parse_cmdline_flags()
	EventLogger.log_event("tc04_auto_flags", {
		"tc04_auto_attempts": tc04_auto_attempts,
		"tc04_auto_timeout_sec": tc04_auto_attempt_timeout_sec,
		"tc04_auto_quit": tc04_auto_quit_on_finish,
	})
	if tc04_auto_attempts > 0:
		tc04_auto_remaining = tc04_auto_attempts
		# Start a fresh run and jump directly into TC04.
		var run_id: int = RunManager.start_run()
		Telemetry.log_event("run_start", {"run_id": run_id, "mode": "tc04_auto"})
		EventLogger.log_event("run_start", {"run_id": run_id, "mode": "tc04_auto"})
		go_to_spike_arena_gauntlet_lane()
		return

func go_to_main_menu() -> void:
	_get_tree_safe().change_scene_to_file(MAIN_MENU_SCENE)

func start_run() -> void:
	# Treat Start as run_start for telemetry.
	var run_id: int = RunManager.start_run()
	Telemetry.log_event("run_start", {"run_id": run_id})
	# Mirror into per-run log for easier TC01 verification (no combat logic changes).
	EventLogger.log_event("run_start", {"run_id": run_id})
	go_to_intent_arena_slasher()

func go_to_test_arena() -> void:
	_get_tree_safe().change_scene_to_file(TEST_ARENA_SCENE)

func go_to_intent_arena_slasher() -> void:
	_get_tree_safe().change_scene_to_file(INTENT_ARENA_SLASHER_SCENE)

func go_to_spike_arena_gauntlet_lane() -> void:
	# When called from autoload _ready(), scene tree can be mid-mutation.
	# Defer to avoid "Parent node is busy" errors (common in headless automation).
	call_deferred("_deferred_change_scene", SPIKE_ARENA_GAUNTLET_LANE_SCENE)

func _deferred_change_scene(scene_path: String) -> void:
	_get_tree_safe().change_scene_to_file(scene_path)

func _parse_cmdline_flags() -> void:
	# Godot splits args into engine args and user args.
	# We want the args passed after `--`.
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.is_empty():
		# Fallback (some launchers may not preserve user args correctly).
		args = OS.get_cmdline_args()

	# TC04 auto-run
	# Examples:
	# - --tc04-auto (defaults to 10)
	# - --tc04-auto=10
	# - --tc04-timeout=6.0
	# - --tc04-no-quit
	if _has_flag(args, "--tc04-auto"):
		tc04_auto_attempts = 10
		var v: String = _get_flag_value(args, "--tc04-auto")
		if v != "":
			tc04_auto_attempts = maxi(0, int(v))
	var t: String = _get_flag_value(args, "--tc04-timeout")
	if t != "":
		tc04_auto_attempt_timeout_sec = maxf(0.5, float(t))
	if _has_flag(args, "--tc04-no-quit"):
		tc04_auto_quit_on_finish = false

func _get_flag_value(args: PackedStringArray, key: String) -> String:
	# Supports:
	# - --key=value
	# - --key value
	for i in range(args.size()):
		var a: String = args[i]
		if a.begins_with(key + "="):
			return a.substr((key + "=").length())
		if a == key and i + 1 < args.size():
			return str(args[i + 1])
	return ""

func _has_flag(args: PackedStringArray, key: String) -> bool:
	for a in args:
		var s := str(a)
		if s == key:
			return true
		if s.begins_with(key + "="):
			return true
	return false

func _get_tree_safe() -> SceneTree:
	var tree := get_tree()
	assert(tree != null)
	return tree

extends Node

# GameApp: Scene routing + high-level app lifecycle.
# Single responsibility for M0: route between MainMenu and TestArena, emit baseline telemetry.

const MAIN_MENU_SCENE: String = "res://scenes/ui/MainMenu.tscn"
const TEST_ARENA_SCENE: String = "res://scenes/levels/TestArena.tscn"
const INTENT_ARENA_SLASHER_SCENE: String = "res://scenes/levels/IntentArena_Slasher.tscn"
const SPIKE_ARENA_GAUNTLET_LANE_SCENE: String = "res://scenes/levels/SpikeArena_GauntletLane.tscn"

var _did_bootstrap: bool = false

func _ready() -> void:
	bootstrap()

func bootstrap() -> void:
	# Defensive: autoload init order isn't guaranteed.
	if _did_bootstrap:
		return
	_did_bootstrap = true

	Telemetry.log_event("app_start", {})
	DataRepo.load_all()
	RunManager.reset_run()

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
	_get_tree_safe().change_scene_to_file(SPIKE_ARENA_GAUNTLET_LANE_SCENE)

func _get_tree_safe() -> SceneTree:
	var tree := get_tree()
	assert(tree != null)
	return tree

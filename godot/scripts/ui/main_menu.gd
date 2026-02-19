extends Control

@onready var start_button: Button = $Center/VBox/StartButton
@onready var tc04_button: Button = $Center/VBox/TC04Button
@onready var playground_button: Button = $Center/VBox/PlaygroundButton
@onready var settings_button: Button = $Center/VBox/SettingsButton
@onready var quit_button: Button = $Center/VBox/QuitButton

func _ready() -> void:
	Telemetry.log_event("scene_loaded", {"scene": "MainMenu"})
	start_button.pressed.connect(_on_start_pressed)
	tc04_button.pressed.connect(_on_tc04_pressed)
	playground_button.pressed.connect(_on_playground_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Quit is desktop-only per M0 spec.
	if OS.has_feature("android") or OS.has_feature("ios") or OS.has_feature("web"):
		quit_button.visible = false

func _on_start_pressed() -> void:
	var app := get_node_or_null("/root/GameApp") as Node
	if app == null:
		push_error("MainMenu: missing autoload '/root/GameApp'")
		return
	app.call("start_run")

func _on_tc04_pressed() -> void:
	var app := get_node_or_null("/root/GameApp") as Node
	if app == null:
		push_error("MainMenu: missing autoload '/root/GameApp'")
		return
	if app.has_method("go_to_spike_arena_gauntlet_lane"):
		app.call("go_to_spike_arena_gauntlet_lane")
		return
	push_warning("MainMenu: GameApp has no spike arena route; falling back to TestArena")
	app.call("go_to_test_arena")

func _on_playground_pressed() -> void:
	var app := get_node_or_null("/root/GameApp") as Node
	if app == null:
		push_error("MainMenu: missing autoload '/root/GameApp'")
		return
	if app.has_method("go_to_combat_playground"):
		app.call("go_to_combat_playground")
		return
	push_warning("MainMenu: GameApp has no playground route; falling back to TestArena")
	app.call("go_to_test_arena")

func _on_settings_pressed() -> void:
	# Placeholder for M0.
	Telemetry.log_event("ui_settings_pressed", {})

func _on_quit_pressed() -> void:
	get_tree().quit()

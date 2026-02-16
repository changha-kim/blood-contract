extends CanvasLayer

@onready var line1: Label = $Panel/VBox/Line1
@onready var line2: Label = $Panel/VBox/Line2
@onready var line3: Label = $Panel/VBox/Line3
@onready var line4: Label = $Panel/VBox/Line4
@onready var line5: Label = $Panel/VBox/Line5
@onready var line6: Label = $Panel/VBox/Line6

@export var room_name: String = "TEST_ARENA"

func _process(_delta: float) -> void:
	line1.text = "FPS: %d" % Engine.get_frames_per_second()
	line2.text = "Run: #%d  Time: %.1fs" % [RunManager.current_run_id, RunManager.get_run_elapsed_sec()]
	line3.text = "Room: %s" % room_name
	line4.text = "Synergy: KB=%d BL=%d SH=%d CU=%d CH=%d" % [
		SynergyManager.get_level("KNOCKBACK"),
		SynergyManager.get_level("BLEED"),
		SynergyManager.get_level("SHIELD"),
		SynergyManager.get_level("CURSE"),
		SynergyManager.get_level("CHAIN"),
	]
	line5.text = "KB Tier: %s" % SynergyManager.get_tier_desc("KNOCKBACK")

	var p := get_tree().get_first_node_in_group("player") as PlayerController
	if p != null:
		line6.text = "Skill1 Shove CD: %.2fs" % p.get_skill1_cooldown_left_sec()
	else:
		line6.text = "Skill1 Shove CD: -"

extends Node

# Minimal M1/M2 implementation: stores tag levels and exposes tier text from data.

var tag_levels: Dictionary = {} # String -> int
var synergy_table: Dictionary = {}

func _ready() -> void:
	synergy_table = DataRepo.get_synergy_table()

func set_level(tag: String, level: int) -> void:
	var prev: int = get_level(tag)
	var next: int = maxi(0, level)
	tag_levels[tag] = next
	var prev_tier: int = _tier_for_level(prev)
	var next_tier: int = _tier_for_level(next)
	if next_tier != prev_tier:
		EventLogger.log_event("synergy_tier", {"tag": tag, "level": next, "tier": next_tier})

func _tier_for_level(level: int) -> int:
	if level >= 4:
		return 4
	if level >= 3:
		return 3
	if level >= 2:
		return 2
	return 0

func get_level(tag: String) -> int:
	return int(tag_levels.get(tag, 0))

func get_tier_desc(tag: String) -> String:
	var tag_def: Dictionary = synergy_table.get(tag, {}) as Dictionary
	var tiers: Dictionary = tag_def.get("tiers", {}) as Dictionary
	var lvl: int = get_level(tag)
	if lvl >= 4 and tiers.has("4"):
		return String(tiers["4"].get("desc", ""))
	if lvl >= 3 and tiers.has("3"):
		return String(tiers["3"].get("desc", ""))
	if lvl >= 2 and tiers.has("2"):
		return String(tiers["2"].get("desc", ""))
	return ""

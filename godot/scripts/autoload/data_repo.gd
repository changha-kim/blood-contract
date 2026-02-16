extends Node

const EXPORT_DIR: String = "res://data/defs"

# Loaded JSON tables keyed by filename base, e.g. "DB_CONTENT_ENEMIES".
var tables: Dictionary = {}

func load_all() -> void:
	tables.clear()
	var dir := DirAccess.open(EXPORT_DIR)
	if dir == null:
		push_warning("DataRepo: missing directory %s" % EXPORT_DIR)
		return

	dir.list_dir_begin()
	var fn := dir.get_next()
	while fn != "":
		if not dir.current_is_dir() and fn.to_lower().ends_with(".json"):
			_load_json_table(fn)
		fn = dir.get_next()
	dir.list_dir_end()

func _load_json_table(filename: String) -> void:
	var table_name := filename.get_basename()
	var path := "%s/%s" % [EXPORT_DIR, filename]
	var json_text := FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(json_text)
	if parsed == null:
		push_warning("DataRepo: failed to parse %s" % path)
		return
	tables[table_name] = parsed

func has_table(table_name: String) -> bool:
	return tables.has(table_name)

func get_table(table_name: String) -> Variant:
	return tables.get(table_name)

func get_dict(table_name: String) -> Dictionary:
	var v: Variant = get_table(table_name)
	return v as Dictionary

func get_player_combat_math() -> Dictionary:
	var root := get_dict("DB_COMBAT_MATH")
	return (root.get("player", {}) as Dictionary)

func get_enemy_defs() -> Dictionary:
	return get_dict("DB_CONTENT_ENEMIES")

func get_hazard_def(hazard_id: String) -> Dictionary:
	# hazards_poc.json
	var root := get_dict("hazards_poc")
	return (root.get(hazard_id, {}) as Dictionary)

func get_enemy_poc_def(enemy_id: String) -> Dictionary:
	# enemies_poc.json
	var root := get_dict("enemies_poc")
	return (root.get(enemy_id, {}) as Dictionary)

func get_player_poc_def() -> Dictionary:
	return get_dict("player_poc")

func get_synergy_table() -> Dictionary:
	return get_dict("DB_SYNERGY_TABLE")

func get_combat_ux() -> Dictionary:
	# CombatUx.json
	return get_dict("CombatUx")

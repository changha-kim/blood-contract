extends Node

# Writes one JSON object per line into user://logs/*.jsonl
# Keep payloads small; prefer ids/ints over large structures.

const LOG_DIR: String = "user://logs"

var _file: FileAccess
var _path: String = ""

func _ready() -> void:
	_open_new_log_file()

func _exit_tree() -> void:
	_flush_and_close()

func _open_new_log_file() -> void:
	DirAccess.make_dir_recursive_absolute(LOG_DIR)
	var ts := Time.get_datetime_string_from_system(true).replace(":", "-")
	_path = "%s/run_%s.jsonl" % [LOG_DIR, ts]
	_file = FileAccess.open(_path, FileAccess.WRITE)
	if _file == null:
		push_warning("EventLogger: failed to open log at %s" % _path)
		return
	log_event("logger_start", {"path": _path})

func get_log_path() -> String:
	return _path

func log_event(event_name: String, payload: Dictionary = {}) -> void:
	if _file == null:
		return
	var evt: Dictionary = {
		"ts_msec": Time.get_ticks_msec(),
		"event": event_name,
	}
	for k in payload.keys():
		evt[k] = payload[k]
	_file.store_line(JSON.stringify(evt))

func _flush_and_close() -> void:
	if _file != null:
		_file.flush()
		_file.close()
		_file = null

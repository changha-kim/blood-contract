extends Node

# Writes 1 JSON object per line into user://logs/*.jsonl
# Keep schema stable: ts_ms, event_name, payload

var _file_path: String = ""

func _ready() -> void:
	_ensure_log_file()

func log_event(event_name: String, payload: Dictionary = {}) -> void:
	_ensure_log_file()
	var entry: Dictionary = {
		"ts_ms": Time.get_ticks_msec(),
		"event_name": event_name,
		"payload": payload,
	}
	var line: String = JSON.stringify(entry)
	# NOTE: FileAccess.WRITE_READ truncates the file. Use READ_WRITE to append.
	var f := FileAccess.open(_file_path, FileAccess.READ_WRITE)
	if f == null:
		push_warning("Telemetry: cannot open log file: %s" % _file_path)
		return
	f.seek_end()
	f.store_line(line)
	f.flush()

func get_log_path() -> String:
	_ensure_log_file()
	return _file_path

func _ensure_log_file() -> void:
	if _file_path != "":
		return
	var dir_path := "user://logs"
	var ok := DirAccess.make_dir_recursive_absolute(dir_path)
	if ok != OK:
		push_warning("Telemetry: failed to ensure dir %s (code=%d)" % [dir_path, ok])
	# Use a stable file name for now; Dev can switch to run_*.jsonl later.
	_file_path = "%s/%s" % [dir_path, "app_telemetry.jsonl"]
	# Touch file
	var f := FileAccess.open(_file_path, FileAccess.WRITE_READ)
	if f != null:
		f.close()

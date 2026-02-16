extends Node
class_name CommitSystem

signal commit_window_opened(window_sec: float)
signal commit_locked()
signal execute_started()
signal recover_started()
signal recover_ended()

# Phases are driven by time; commit lock moment occurs at lock_at_sec inside telegraph.

var telegraph_sec: float = 0.35
var lock_at_sec: float = 0.20
var execute_sec: float = 0.12
var recover_sec: float = 0.35

var _running: bool = false
var _t: float = 0.0
var _locked_emitted: bool = false

func configure_from_dict(d: Dictionary) -> void:
	if d.has("telegraph_sec"):
		telegraph_sec = float(d["telegraph_sec"])
	if d.has("lock_at_sec"):
		lock_at_sec = float(d["lock_at_sec"])
	if d.has("execute_sec"):
		execute_sec = float(d["execute_sec"])
	if d.has("recover_sec"):
		recover_sec = float(d["recover_sec"])

	# Clamp for sanity.
	telegraph_sec = maxf(0.05, telegraph_sec)
	lock_at_sec = clampf(lock_at_sec, 0.0, telegraph_sec)
	execute_sec = maxf(0.01, execute_sec)
	recover_sec = maxf(0.01, recover_sec)

func start() -> void:
	_running = true
	_t = 0.0
	_locked_emitted = false
	commit_window_opened.emit(telegraph_sec)

func stop() -> void:
	_running = false

func is_running() -> bool:
	return _running

func get_time_in_telegraph() -> float:
	return _t

func get_lock_at_sec() -> float:
	return lock_at_sec

func _process(delta: float) -> void:
	if not _running:
		return
	_t += delta

	if (not _locked_emitted) and _t >= lock_at_sec:
		_locked_emitted = true
		commit_locked.emit()

	if _t >= telegraph_sec + execute_sec + recover_sec:
		_running = false
		recover_ended.emit()
		return

	# Boundary signals (best-effort; consumer can also map by time).
	if _t >= telegraph_sec and _t - delta < telegraph_sec:
		execute_started.emit()
	if _t >= telegraph_sec + execute_sec and _t - delta < telegraph_sec + execute_sec:
		recover_started.emit()

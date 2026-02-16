extends Node

# RunManager: run lifecycle placeholder.
# Single responsibility for M0: maintain a monotonically increasing run_id.

signal run_reset()
signal run_started(run_id: int)

var current_run_id: int = 0
var _run_start_msec: int = 0

func reset_run() -> void:
	current_run_id = 0
	_run_start_msec = 0
	run_reset.emit()

func start_run() -> int:
	current_run_id += 1
	_run_start_msec = Time.get_ticks_msec()
	run_started.emit(current_run_id)
	return current_run_id

func get_run_elapsed_sec() -> float:
	if _run_start_msec <= 0:
		return 0.0
	return float(Time.get_ticks_msec() - _run_start_msec) / 1000.0

extends Node
class_name IntentStateMachine

signal phase_changed(old_phase: Phase, new_phase: Phase)

enum Phase {
	IDLE,
	TELEGRAPH,
	COMMIT_LOCKED,
	EXECUTE,
	RECOVER,
}

var phase: Phase = Phase.IDLE

func set_phase(next: Phase) -> void:
	if next == phase:
		return
	var old := phase
	phase = next
	phase_changed.emit(old, next)

func is_committed() -> bool:
	return phase == Phase.COMMIT_LOCKED or phase == Phase.EXECUTE or phase == Phase.RECOVER

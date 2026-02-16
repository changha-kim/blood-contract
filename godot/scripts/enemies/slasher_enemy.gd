extends CharacterBody2D
class_name SlasherEnemy

signal telegraph_started()
signal locked()
signal executed()
signal recovered()

@export var target_path: NodePath

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Attack/Hitbox
@onready var attack_root: Node2D = $Attack
@onready var intent_sm: IntentStateMachine = $IntentStateMachine
@onready var commit: CommitSystem = $CommitSystem

var move_speed: float = 180.0
var engage_range_px: float = 150.0
var attack_range_px: float = 52.0
var hitbox_active_sec: float = 0.10

var _target: Node2D
var _facing: Vector2 = Vector2.LEFT

func _ready() -> void:
	_apply_tuning()
	_target = get_node_or_null(target_path) as Node2D
	commit.commit_locked.connect(_on_locked)
	commit.execute_started.connect(_on_execute)
	commit.recover_started.connect(_on_recover)
	commit.recover_ended.connect(_on_idle)

func _physics_process(delta: float) -> void:
	if _target == null:
		return
	var to_t := _target.global_position - global_position
	var dist := to_t.length()
	if dist > 0.001:
		_facing = to_t.normalized()

	if intent_sm.phase == IntentStateMachine.Phase.IDLE:
		if dist <= engage_range_px:
			_start_intent()
		else:
			velocity = _facing * move_speed
			move_and_slide()
	elif intent_sm.phase == IntentStateMachine.Phase.TELEGRAPH:
		# Hold position to be readable.
		velocity = Vector2.ZERO
		move_and_slide()
	elif intent_sm.is_committed():
		velocity = Vector2.ZERO
		move_and_slide()

func _start_intent() -> void:
	intent_sm.set_phase(IntentStateMachine.Phase.TELEGRAPH)
	telegraph_started.emit()
	EventLogger.log_event("intent_telegraph", {"who": "slasher"})
	commit.start()

func _on_locked() -> void:
	intent_sm.set_phase(IntentStateMachine.Phase.COMMIT_LOCKED)
	locked.emit()
	EventLogger.log_event("intent_commit", {"who": "slasher", "result": "locked"})

func _on_execute() -> void:
	intent_sm.set_phase(IntentStateMachine.Phase.EXECUTE)
	executed.emit()
	EventLogger.log_event("intent_execute", {"who": "slasher"})
	attack_root.rotation = _facing.angle()
	_hitbox_pulse(hitbox_active_sec)

func _on_recover() -> void:
	intent_sm.set_phase(IntentStateMachine.Phase.RECOVER)
	recovered.emit()
	EventLogger.log_event("intent_recover", {"who": "slasher"})

func _on_idle() -> void:
	intent_sm.set_phase(IntentStateMachine.Phase.IDLE)

func _hitbox_pulse(duration_sec: float) -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(duration_sec).timeout
	hitbox.monitoring = false

func _apply_tuning() -> void:
	var root := DataRepo.get_dict("CombatTuning")
	var d := root.get("slasher", {}) as Dictionary
	if d.has("move_speed"):
		move_speed = float(d["move_speed"])
	if d.has("engage_range_px"):
		engage_range_px = float(d["engage_range_px"])
	var intent_def := d.get("intent", {}) as Dictionary
	commit.configure_from_dict(intent_def)
	if intent_def.has("attack_range_px"):
		attack_range_px = float(intent_def["attack_range_px"])
	if intent_def.has("hitbox_active_sec"):
		hitbox_active_sec = float(intent_def["hitbox_active_sec"])

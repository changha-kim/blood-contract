extends EnemyBase

func _ready() -> void:
	enemy_id = "ENY_SLASHER"
	super._ready()

func get_telegraph_sec() -> float:
	return 0.6

func get_commit_sec() -> float:
	return 0.18

func get_execute_sec() -> float:
	return 0.10

func get_recover_sec() -> float:
	return 0.55

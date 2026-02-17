extends SceneTree

# DEV-002 QA smoke (headless): verifies basic movement stability, dash cooldown/iframes toggling,
# and attack debug line spawn for TestArena + IntentArena_Slasher.

var failures: Array[String] = []

func _initialize() -> void:
	print("[QA_SMOKE_DEV002] start")
	await _run_scene("res://scenes/levels/TestArena.tscn")
	await _run_scene("res://scenes/levels/IntentArena_Slasher.tscn")

	if failures.is_empty():
		print("[QA_SMOKE_DEV002] PASS")
	else:
		print("[QA_SMOKE_DEV002] FAIL (%d)" % failures.size())
		for f in failures:
			print(" - %s" % f)

	quit()

func _run_scene(scene_path: String) -> void:
	print("[QA_SMOKE_DEV002] scene: %s" % scene_path)
	var ps := load(scene_path)
	if ps == null or !(ps is PackedScene):
		failures.append("Could not load PackedScene: %s" % scene_path)
		return

	var root := (ps as PackedScene).instantiate()
	if root == null:
		failures.append("Could not instantiate: %s" % scene_path)
		return

	root.name = "__qa_root__"
	self.root.add_child(root)

	var player := root.get_node_or_null("Player")
	if player == null:
		failures.append("Player node missing in %s" % scene_path)
		root.queue_free()
		await process_frame
		return

	# 60s movement stability: run physics while moving, ensure no crash/errors.
	# (Headless approximation of manual QA.)
	if player.has_method("set_move_dir"):
		player.set_move_dir(Vector2.RIGHT)
	await _step_seconds(30.0)
	if player.has_method("set_move_dir"):
		player.set_move_dir(Vector2.LEFT)
	await _step_seconds(30.0)
	if player.has_method("set_move_dir"):
		player.set_move_dir(Vector2.ZERO)
	await _step_seconds(0.5)

	# Dash: call internal method directly (Input isn't available headless).
	if player.has_method("_try_dash"):
		player.set_move_dir(Vector2.RIGHT)
		player._try_dash()
		await process_frame
		# Immediately after dash, cooldown should be > 0
		var cd := 0.0
		if player.has_method("get_dash_cooldown_remaining"):
			cd = float(player.get_dash_cooldown_remaining())
		if cd <= 0.0:
			failures.append("Dash cooldown not set (>0) in %s" % scene_path)

		# Invulnerability should start true then end after dash_invuln_sec.
		var hurtbox := player.get_node_or_null("Hurtbox")
		if hurtbox == null:
			failures.append("Hurtbox missing under Player in %s" % scene_path)
		else:
			if !hurtbox.get("invulnerable"):
				failures.append("Hurtbox.invulnerable not true right after dash in %s" % scene_path)
			# wait enough for invuln end
			await _step_seconds( max(0.2, float(player.get("dash_invuln_sec")) + 0.05) )
			if hurtbox.get("invulnerable"):
				failures.append("Hurtbox.invulnerable still true after invuln window in %s" % scene_path)
	else:
		failures.append("Player has no _try_dash() method in %s" % scene_path)

	# Attack visibility: verify a Line2D is created briefly.
	if player.has_method("_do_attack"):
		var before := _count_children_of_type(player, "Line2D")
		player._do_attack()
		await process_frame
		var after := _count_children_of_type(player, "Line2D")
		if after <= before:
			failures.append("Attack debug Line2D did not spawn in %s" % scene_path)
		# it should also clean itself up within attack_visual_sec; wait a bit more.
		await _step_seconds(0.2)
	else:
		failures.append("Player has no _do_attack() method in %s" % scene_path)

	root.queue_free()
	await process_frame

func _count_children_of_type(n: Node, type_name: String) -> int:
	var c := 0
	for ch in n.get_children():
		if ch.get_class() == type_name:
			c += 1
	return c

func _step_seconds(sec: float) -> void:
	var t := 0.0
	while t < sec:
		await physics_frame
		t += 1.0 / 60.0

extends Node

func _ready() -> void:
	print("--- Running Test Safe Move and Slide Runner ---")
	call_deferred("_run_test")

func _run_test() -> void:
	var player_scene = load("res://player.tscn")
	if not player_scene:
		print("FAIL: Could not load player.tscn")
		get_tree().quit(1)
		return

	var player = player_scene.instantiate()
	get_tree().root.add_child(player)
	await get_tree().process_frame

	# Set invalid / NaN / near zero edge-case velocities
	player.velocity = Vector2(NAN, NAN)
	player.up_direction = Vector2(NAN, NAN)
	player.safe_move_and_slide()
	if player.velocity != Vector2.ZERO or player.up_direction != Vector2.UP:
		print("FAIL: safe_move_and_slide did not reset NaN velocity or up_direction")
		get_tree().quit(1)
		return

	# Near-zero floating point precision test
	player.velocity = Vector2(0.000000001, 0.000000001)
	player.safe_move_and_slide()
	if player.velocity != Vector2.ZERO:
		print("FAIL: safe_move_and_slide did not clean subnormal velocity")
		get_tree().quit(1)
		return

	print("PASS: safe_move_and_slide handles NaN and precision edge cases cleanly!")
	print("--- All tests passed! ---")
	get_tree().quit(0)

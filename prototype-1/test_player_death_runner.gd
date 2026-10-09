extends Node

func _ready() -> void:
	print("--- Running Test Player Death Runner ---")
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
	
	player.health = 1
	player.take_damage(10)
	
	if player.current_state == player.State.DEATH:
		print("PASS: Player transitioned to DEATH state successfully.")
	else:
		print("FAIL: Player did not transition to DEATH state.")
		get_tree().quit(1)
		return

	# Further damage while dead should be safely ignored
	player.take_damage(50)
	if player.health == -9:
		print("PASS: Extra take_damage calls ignored during DEATH state.")
	else:
		print("FAIL: Player health modified while dead.")
		get_tree().quit(1)
		return

	print("--- All tests passed! ---")
	get_tree().quit(0)

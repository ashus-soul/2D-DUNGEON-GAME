extends SceneTree

func _init() -> void:
	print("--- Running Test Player Death ---")
	
	# Load level_1.tscn so autoloads like Global and SceneTransition are loaded properly
	change_scene_to_file("res://level_1.tscn")
	await process_frame
	await process_frame
	
	var player = root.get_node_or_null("level1/player")
	if not player:
		print("FAIL: Could not find player in level_1")
		quit(1)
		return

	# Trigger death safely
	player.health = 1
	player.take_damage(10)
	
	if player.current_state == player.State.DEATH:
		print("PASS: Player transitioned to DEATH state successfully.")
	else:
		print("FAIL: Player did not transition to DEATH state.")
		quit(1)
		return

	# Further damage while dead should do nothing and not throw errors
	player.take_damage(50)
	if player.health == -9:
		print("PASS: Extra take_damage calls ignored during DEATH state.")
	else:
		print("FAIL: Player health modified while dead.")
		quit(1)
		return

	print("--- All tests passed! ---")
	quit(0)



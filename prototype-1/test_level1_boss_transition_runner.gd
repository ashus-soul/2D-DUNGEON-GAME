extends Node

func _ready():
	print("--- RUNNING LEVEL 1 BOSS 1 DEATH TRANSITION TEST VIA SCENE ---")
	call_deferred("_run_test")

func _run_test():
	var level1_scene = load("res://level_1.tscn")
	assert(level1_scene != null, "level_1.tscn should load successfully")
	
	var level1_node = level1_scene.instantiate()
	get_tree().root.add_child(level1_node)
	
	# Verify boss node reference
	var boss = level1_node.boss
	assert(boss != null, "level_1 script must successfully resolve boss node 'Boss1'")
	assert(boss.name == "Boss1", "Boss node name must be Boss1")
	assert(boss.has_signal("boss_died"), "Boss node must have 'boss_died' signal")
	
	# Verify initial state
	assert(level1_node.boss_defeated == false, "boss_defeated must initially be false")
	
	# Trigger boss_died signal directly
	boss.boss_died.emit()
	
	assert(level1_node.boss_defeated == true, "_on_boss_died must be called on boss_died signal emission")
	assert(level1_node.next_level != null, "next_level must be set to background.tscn in level_1.tscn")
	assert(level1_node.next_level.resource_path == "res://background.tscn", "next_level path must be res://background.tscn")
	
	print("[PASS] level_1 correctly handles Boss1 death signal and has next_level set to background.tscn!")
	level1_node.queue_free()
	get_tree().quit(0)

extends Node

var currency = 0
var killed = 0
var t = clampf(killed / 250.0, 0.0, 1.0)
var enemies = [
	{ "scene": preload("res://enemies/basic_enemy.tscn"), "weight": 60 },
	{ "scene": preload("res://enemies/fast_enemy.tscn"), "weight": 30 },
	{ "scene": preload("res://enemies/tank_enemy.tscn"), "weight": 10 }
]

func spawn_enemies(container, screen_size, count:int = 3):
	for i in count:
		var enemyScene = pick_enemy()
		var newEnemy = enemyScene.instantiate()
		
		var cam = get_viewport().get_camera_2d()
		var cam_pos = cam.get_screen_center_position() if cam else Vector2.ZERO
		
		var top_left = cam_pos - (screen_size / 2)
		var bottom_right = cam_pos + (screen_size / 2)
		
		var margin = 100
		var spawn_pos = Vector2.ZERO
		var side = randi() % 4
		
		match side:
			0: # Top
				spawn_pos.x = randf_range(top_left.x, bottom_right.x)
				spawn_pos.y = top_left.y - margin
			1: # Bottom
				spawn_pos.x = randf_range(top_left.x, bottom_right.x)
				spawn_pos.y = bottom_right.y + margin
			2: # Left
				spawn_pos.x = top_left.x - margin
				spawn_pos.y = randf_range(top_left.y, bottom_right.y)
			3: # Right
				spawn_pos.x = bottom_right.x + margin
				spawn_pos.y = randf_range(top_left.y, bottom_right.y)
		
		newEnemy.global_position = spawn_pos
		
		var scale = lerp(1.0, 3.5, t * t)
		
		container.add_child(newEnemy)

func pick_enemy():
	var total_weight = 0
	
	for e in enemies:
		total_weight += e.weight
	
	var roll = randi_range(1, total_weight)
	var cumulative = 0
	
	for e in enemies:
		cumulative += e.weight
		if roll <= cumulative:
			return e.scene
	
	return enemies[0].scene

func updateUI():
	var canvas = get_tree().current_scene.get_node("Player").get_node("Camera2D").get_node("UI")
	var kills = canvas.get_node("kills").get_node("Label")
	var money = canvas.get_node("currency").get_node("Label")
	
	kills.text = "Killed: " + str(killed)
	money.text = "Currency: $" + str(currency)
	
const SHOP_THRESHOLDS: Array[int] = [5, 30, 60, 100, 150, 210, 250]
var threshold_index: int = 0

func _check_threshold() -> void:
	if threshold_index >= SHOP_THRESHOLDS.size():
		return
	if killed >= SHOP_THRESHOLDS[threshold_index]:
		threshold_index += 1
		warp()

func enemy_killed():
	updateUI()
	currency += int(randi_range(1, 25) * lerp(1.0, 3.0, t * t))
	killed += 1
	_check_threshold()
	print(currency)

func warp() -> void:
	var is_final = threshold_index >= SHOP_THRESHOLDS.size()

	if is_final:
		call_deferred("change_to_scene","res://main.tscn")
	else:
		call_deferred("change_to_scene","res://upgrades.tscn")

func change_to_scene(path:String):
	get_tree().change_scene_to_file(path)

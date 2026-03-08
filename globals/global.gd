extends Node

var currency = 0
var killed = 0
var t = clampf(killed / 250.0, 0.0, 1.0)

func spawn_enemy(container, screen_size):
	var enemyScene = preload("res://enemies/basic_enemy.tscn")
	var newEnemy = enemyScene.instantiate()
	
	var cam = get_viewport().get_camera_2d()
	
	var cam_pos = cam.get_screen_center_position() if cam else Vector2.ZERO
	
	var top_left = cam_pos - (screen_size / 2)
	var bottom_right = cam_pos + (screen_size / 2)
	
	var margin = 100 
	var spawn_pos = Vector2.ZERO
	var side = randi() % 4 
	
	match side:
		0: # Top (Above the camera view)
			spawn_pos.x = randf_range(top_left.x, bottom_right.x)
			spawn_pos.y = top_left.y - margin
		1: # Bottom (Below the camera view)
			spawn_pos.x = randf_range(top_left.x, bottom_right.x)
			spawn_pos.y = bottom_right.y + margin
		2: # Left (To the left of camera view)
			spawn_pos.x = top_left.x - margin
			spawn_pos.y = randf_range(top_left.y, bottom_right.y)
		3: # Right (To the right of camera view)
			spawn_pos.x = bottom_right.x + margin
			spawn_pos.y = randf_range(top_left.y, bottom_right.y)
	
	newEnemy.global_position = spawn_pos
	newEnemy.damage = int(randi_range(5, min(20 + int(55 * t * t), 75)))
	newEnemy.speed = randf_range(10.0, lerp(5.0, 65.0, t * t))
	
	var hp_node = newEnemy.get_node("HealthComponent")
	var scale = lerp(1.0, 3.5, t * t)

	if hp_node:
		hp_node.max_health = int(randi_range(50, 150) * scale)
		hp_node.max_health = round(hp_node.max_health / 10.0) * 10
		hp_node.current_health = hp_node.max_health

	container.add_child(newEnemy)
	
func updateUI():
	var canvas = get_tree().current_scene.get_node("Player").get_node("Camera2D").get_node("UI")
	var kills = canvas.get_node("kills").get_node("Label")
	var money = canvas.get_node("currency").get_node("Label")
	
	kills.text = "Killed: " + str(killed)
	money.text = "Currency: $" + str(currency)
	
const SHOP_THRESHOLDS: Array[int] = [2, 30, 60, 100, 150, 210, 250]
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

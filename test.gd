extends Node2D

@onready var spawner = $Timer

var window_width = DisplayServer.window_get_size().x
var window_height = DisplayServer.window_get_size().y

func _ready() -> void:
	$Timer.wait_time = randi_range(1.0, 5.0)
	$Player.global_position = Vector2(window_width/2, window_height/2)

func _on_timer_timeout() -> void:
	spawn_enemy()
	$Timer.wait_time = randi_range(1.0, 5.0)
	
func spawn_enemy():
	var enemyScene = preload("res://enemies/basic_enemy.tscn")
	var newEnemy = enemyScene.instantiate()
	
	# 1. Get the current camera to see where the player is looking
	var cam = get_viewport().get_camera_2d()
	var screen_size = get_viewport_rect().size
	
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
	
	var hp_node = newEnemy.get_node("HealthComponent")
	
	if hp_node:
		hp_node.max_health = randi_range(50,200)
		hp_node.current_health = hp_node.max_health 

	$enemies.add_child(newEnemy)

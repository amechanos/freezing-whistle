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
	var screen_size = get_viewport_rect().size
	var margin = 100 # How far outside the screen they spawn
	
	var spawn_pos = Vector2.ZERO
	var side = randi() % 4 # Pick a random side: 0, 1, 2, or 3
	
	match side:
		0: # Top
			spawn_pos.x = randf_range(0, screen_size.x)
			spawn_pos.y = -margin
		1: # Bottom
			spawn_pos.x = randf_range(0, screen_size.x)
			spawn_pos.y = screen_size.y + margin
		2: # Left
			spawn_pos.x = -margin
			spawn_pos.y = randf_range(0, screen_size.y)
		3: # Right
			spawn_pos.x = screen_size.x + margin
			spawn_pos.y = randf_range(0, screen_size.y)
			
	newEnemy.global_position = spawn_pos
	
	var hp_node = newEnemy.get_node("HealthComponent")
	
	if hp_node:
		hp_node.max_health = randi_range(50,200)
		hp_node.current_health = hp_node.max_health 

	$enemies.add_child(newEnemy)

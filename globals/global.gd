extends Node2D

const STARTING_KILL_COUNT_GOAL = 5
const KILL_COUNT_INCREASE = 5
const MAX_ENEMIES = 25

var spawner : Timer
var player : Player

var window_width = DisplayServer.window_get_size().x
var window_height = DisplayServer.window_get_size().y

var current_round : int = 0
var current_enemy_kill_count : int = 0
var current_kill_goal : int = STARTING_KILL_COUNT_GOAL
var currency = 0

signal currency_updated(new_amount:int)
signal round_started(_current_round:int)
signal round_ended

func set_up() -> void:
	await get_tree().create_timer(1.0).timeout
	print('timeout')
	spawner = Timer.new()
	spawner.wait_time = randf_range(1.0, 5.0)
	spawner.timeout.connect(_on_timer_timeout)
	get_tree().current_scene.add_child(spawner)
	player = get_tree().get_first_node_in_group('player')
	start_round()

func start_round() -> void:
	current_round += 1
	round_started.emit(current_round)
	spawner.start()
	player.global_position = Vector2(window_width/2, window_height/2)
	print('starting round')

func end_round():
	#Stop the timer and wait for upgrades to be choosen
	spawner.stop()
	
	#set the new kill goal
	current_kill_goal = clampi(STARTING_KILL_COUNT_GOAL * current_round, STARTING_KILL_COUNT_GOAL, MAX_ENEMIES)
	
	#free all current enemies
	for enemy in get_tree().get_nodes_in_group('enemies'):
		enemy.queue_free()
	
	#send out a signal to let everything know the rounds ended ie player ui and player
	round_ended.emit()
	current_enemy_kill_count = 0

func _on_timer_timeout() -> void:
	spawn_enemy()
	spawner.wait_time = randf_range(1.0, 5.0)

func enemy_died(coin_amount : int):
	#when an enemy died they send out a signal that connects here and updates values below
	currency += coin_amount
	currency_updated.emit(currency)
	current_enemy_kill_count += 1
	
	if current_enemy_kill_count >= current_kill_goal:
		end_round()

func spawn_enemy():
	var enemyScene = preload("res://enemies/basic_enemy.tscn")
	var newEnemy = enemyScene.instantiate()
	
	# 1. Get the current camera to see where the player is looking
	var cam = get_viewport().get_camera_2d() 
	var screen_size = get_viewport_rect().size * (cam.zoom + Vector2(1.5, 1.5)) #brute forced this bitch to work with zoom im sure theres a better way to do this ignore the magic numbers
	
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
	
	#Moved health setting to health component

	get_tree().current_scene.add_child(newEnemy)

func load_game_scene():
	get_tree().change_scene_to_file("res://test.tscn")
	set_up()

func end_game():
	currency = 0
	current_round = 1
	current_kill_goal = 5
	current_enemy_kill_count = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") #Change this to show game over screen

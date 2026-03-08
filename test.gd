extends Node2D

@onready var spawner = $Timer
var window_width = DisplayServer.window_get_size().x
var window_height = DisplayServer.window_get_size().y

func _ready() -> void:
	$Player.global_position = Vector2(window_width / 2, window_height / 2)
	$Timer.wait_time = lerp(5.0, 0.4, 0.0)  # = 5.0, clean start

func _on_timer_timeout() -> void:
	var t = clampf(Global.killed / 250.0, 0.0, 1.0)
	
	# 1 enemy early, up to 3 near 250
	var spawn_count = 1 + int(t * t * 2)
	for i in spawn_count:
		Global.spawn_enemy($enemies, get_viewport_rect().size)
	
	# 5s → 0.4s floor, with slight jitter so it never feels mechanical
	$Timer.wait_time = lerp(5.0, 0.4, t * t) + randf_range(-0.2, 0.2)

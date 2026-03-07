extends Node2D
class_name WeaponHolder

@onready var graphics : Sprite2D = $"../WeaponPivot/Sprite2D"
@onready var firing_point : Marker2D = $"../WeaponPivot/FiringPoint"

@export var bullet_count : int = 1
@export_range(0, 1) var arc : float = 0
@export_range(0, 20) var fire_rate : float = 1.5

@export var burst_size : int = 15
@export var burst_cooldown: int = 10
@export_range(0, 1) var time_tween_shots : float = 0.25

var bullet_scene = preload("res://bullets/basic_bullet.tscn")

var can_shoot : bool = true
var can_shoot_burst : bool = true

signal shot_fired()
signal update_ui()

func shoot():
	print("Shooting!")
	if !can_shoot:
		print("Can't shoot")
		return
		
	can_shoot = false

	for i in bullet_count:
		create_bullet(i)
	shot_fired.emit()

	await get_tree().create_timer(1.0 / fire_rate).timeout
	can_shoot = true

### NEED TO FIX!
func burst(): # Rapid fire 25 snowballs (E Ability)
	print("Shooting!") 
	if !can_shoot:
		print("Can't shoot")
		return
		
	can_shoot_burst = false

	for i in burst_size:
		print("Bullet shot!")
		create_bullet(i)
		shot_fired.emit()
		await get_tree().create_timer(time_tween_shots).timeout
		
	await get_tree().create_timer(burst_cooldown).timeout
	can_shoot_burst = true
	
func create_bullet(i: int):
	var new_bullet : Node2D = bullet_scene.instantiate()
	new_bullet.global_position = firing_point.global_position

	if bullet_count == 1:
		new_bullet.global_rotation = firing_point.global_rotation + randf_range(-arc, arc)
	else:
		var arc_rad = deg_to_rad(arc)
		var increment = arc_rad / (bullet_count - 1)
		new_bullet.global_rotation = (
			global_rotation + randf_range(-arc, arc) +
			increment * i -
			arc_rad / 2
		)

	get_tree().current_scene.add_child(new_bullet)

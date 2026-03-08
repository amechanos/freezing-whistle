extends Node2D
class_name WeaponHolder

@onready var graphics : Sprite2D = $"../WeaponPivot/Sprite2D"
@onready var firing_point : Marker2D = $"../WeaponPivot/FiringPoint"

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

	for i in amProps.bullet_count:
		create_bullet(i)
	shot_fired.emit()

	await get_tree().create_timer(1.0 / amProps.fire_rate).timeout
	can_shoot = true

func burst(): # Rapid fire for X seconds (E Ability)
	if !can_shoot_burst:
		print("Burst on cooldown")
		return
		
	can_shoot_burst = false
	can_shoot = false
	print("Shooting!") 

	var duration_timer = get_tree().create_timer(amProps.burst_duration)
	
	# Keep shooting as long as the timer hasn't timed out
	while duration_timer.get_time_left() > 0:
		print("Bullet shot!")
		create_bullet(1)
		shot_fired.emit()
		
		await get_tree().create_timer(amProps.time_between_shots).timeout
		
	# Start the overall ability cooldown after the shooting ends
	can_shoot = true
	await get_tree().create_timer(amProps.burst_cooldown).timeout
	can_shoot_burst = true
	
	
func create_bullet(i: int):
	var new_bullet : Node2D = bullet_scene.instantiate()
	new_bullet.global_position = firing_point.global_position

	if amProps.bullet_count == 1:
		new_bullet.global_rotation = firing_point.global_rotation + randf_range(-amProps.arc, amProps.arc)
	else:
		var arc_rad = deg_to_rad(amProps.arc)
		var increment = arc_rad / (amProps.bullet_count - 1)
		new_bullet.global_rotation = (
			global_rotation + randf_range(-amProps.arc, amProps.arc) +
			increment * i -
			arc_rad / 2
		)

	get_tree().current_scene.add_child(new_bullet)

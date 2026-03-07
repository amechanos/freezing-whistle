extends Node2D
class_name WeaponHolder

@onready var graphics : Sprite2D = $"../WeaponPivot/Sprite2D"
@onready var firing_point : Marker2D = $"../WeaponPivot/FiringPoint"

@export var current_weapon : WeaponData

var can_shoot : bool = true

signal shot_fired(weapon: WeaponData)
signal update_ui(weapon: WeaponData)

func _ready() -> void:
	if current_weapon:
		current_weapon = current_weapon.duplicate()
	update_ui.emit(current_weapon)

func shoot():
	if current_weapon == null or !can_shoot:
		return
	can_shoot = false

	for i in current_weapon.bullet_count:
		create_bullet(i)
	shot_fired.emit(current_weapon)

	await get_tree().create_timer(1.0 / current_weapon.fire_rate).timeout
	can_shoot = true

### NEED TO FIX!
func burst(): # Rapid fire 25 snowballs (E Ability) 
	if current_weapon == null or !can_shoot:
		return
	can_shoot = false

	for i in current_weapon.burst_size:
		create_bullet(i)
		shot_fired.emit(current_weapon)

		if i < current_weapon.burst_size - 1:
			await get_tree().create_timer(current_weapon.time_tween_shots).timeout
			
	can_shoot = true
	await get_tree().create_timer(current_weapon.burst_cooldown).timeout

func create_bullet(i: int):
	var new_bullet : Node2D = current_weapon.bullet_scene.instantiate()
	new_bullet.global_position = firing_point.global_position

	if current_weapon.bullet_count == 1:
		new_bullet.global_rotation = firing_point.global_rotation + randf_range(-current_weapon.arc, current_weapon.arc)
	else:
		var arc_rad = deg_to_rad(current_weapon.arc)
		var increment = arc_rad / (current_weapon.bullet_count - 1)
		new_bullet.global_rotation = (
			global_rotation + randf_range(-current_weapon.arc, current_weapon.arc) +
			increment * i -
			arc_rad / 2
		)

	get_tree().current_scene.add_child(new_bullet)

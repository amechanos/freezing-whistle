extends Node2D
class_name WeaponHolder

@onready var graphics : Sprite2D = $"../Sprite2D"
@onready var firing_point : Marker2D = $"../FiringPoint"

@export var current_weapon : WeaponData

var bullets_shot : int = 0
var can_shoot : bool = true

signal switched_weapon(weapon:WeaponData)
signal shot_fired(weapon:WeaponData)
signal update_ui(weapon:WeaponData)

func _ready() -> void:
	if current_weapon:
		current_weapon = current_weapon.duplicate()
	
	update_graphics()


func update_graphics():
	switched_weapon.emit(current_weapon)
	update_ui.emit(current_weapon)

func shoot():
	if current_weapon == null or !can_shoot: 
		return
	
	can_shoot = false
	
	#no idea what I did but it worked
	if current_weapon.burst_size > 0:
		while bullets_shot <= current_weapon.burst_size:
			if bullets_shot != 0:
				await get_tree().create_timer(current_weapon.time_tween_shots).timeout
			
			for i in current_weapon.bullet_count:
				create_bullet(i)
			bullets_shot += 1
	else:
		for i in current_weapon.bullet_count:
			create_bullet(i)
		
		shot_fired.emit()
	
	await get_tree().create_timer(1 / current_weapon.fire_rate).timeout
	bullets_shot = 0
	can_shoot = true

func create_bullet(i : int):
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

func get_weapon(data : WeaponData) -> WeaponData:
	if current_weapon == data:
		return current_weapon
	return null

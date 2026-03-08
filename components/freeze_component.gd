extends Node2D
class_name FreezeComponent

const FREEZE_AREA = preload("res://freeze_area/freeze_area.tscn")

<<<<<<< HEAD
var can_freeze = true

signal freeze_triggered
signal ability_cooldown_started(ability_name: String, duration: float)

func create_freeze():
	print(can_freeze)
	if !can_freeze:
		return
		
	var new_freeze_area = FREEZE_AREA.instantiate()
	freeze_triggered.emit()
	new_freeze_area.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(new_freeze_area)
	can_freeze = false
	ability_cooldown_started.emit("freeze", amProps.freezeCooldown)
	await get_tree().create_timer(amProps.freezeCooldown).timeout
	can_freeze = true
=======
signal freeze_triggered

func create_freeze():
	var new_freeze_area : FreezeArea = FREEZE_AREA.instantiate()
	freeze_triggered.emit()
	new_freeze_area.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(new_freeze_area)
>>>>>>> 88172775f3f0d332bfbca45bec3a182bbb69d4e6

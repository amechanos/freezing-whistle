extends Node2D
class_name FreezeComponent

const FREEZE_AREA = preload("res://freeze_area/freeze_area.tscn")

var can_freeze = true

signal freeze_triggered

func create_freeze():
	print(can_freeze)
	if !can_freeze:
		return
		
	var new_freeze_area = FREEZE_AREA.instantiate()
	freeze_triggered.emit()
	new_freeze_area.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(new_freeze_area)
	can_freeze = false
	await get_tree().create_timer(amProps.freezeCooldown).timeout
	can_freeze = true

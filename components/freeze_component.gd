extends Node2D
class_name FreezeComponent

const FREEZE_AREA = preload("res://freeze_area/freeze_area.tscn")

signal freeze_triggered

func create_freeze():
	var new_freeze_area : FreezeArea = FREEZE_AREA.instantiate()
	freeze_triggered.emit()
	new_freeze_area.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(new_freeze_area)

extends Area2D
class_name FreezeableObject

var is_frozen : bool = false

signal froze
signal unfrozen

func _ready() -> void:
	add_to_group("freezeable_objects")

func freeze():
	is_frozen = true
	froze.emit()

func unfreeze():
	is_frozen = false
	unfrozen.emit()

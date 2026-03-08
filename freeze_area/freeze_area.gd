extends Area2D
class_name FreezeArea

@onready var timer : Timer = $Timer
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var freezeable_objects_in_area : Array[Node2D] = []

func _ready() -> void:
	collision_shape.shape.radius = amProps.freezeSize
	timer.wait_time = amProps.freezeDur
	
	take_snapshot()
	queue_redraw()

func take_snapshot():
	await get_tree().create_timer(0.1).timeout
	
	var targets = get_overlapping_areas()
	for body in targets:
		if body is FreezeableObject:
			body.freeze()
			freezeable_objects_in_area.append(body)
	
	monitoring = false 
	monitorable = false
	
	await get_tree().create_timer(amProps.freezeDur).timeout
	unfreeze()

func unfreeze():
	for obj in freezeable_objects_in_area:
		if is_instance_valid(obj) and obj.has_method("unfreeze"):
			obj.unfreeze()
	queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, amProps.freezeSize, Color(0.314, 0.486, 1.0, 0.392))

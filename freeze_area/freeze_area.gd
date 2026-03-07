extends Area2D
class_name FreezeArea

@onready var timer : Timer = $Timer
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

@export var size : float = 150
@export var time : float = 2

var freezeable_objects_in_area : Array[FreezeableObject]

func _ready() -> void:
	collision_shape.shape.radius = size
	timer.wait_time = time
	timer.start()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, size, Color(0.314, 0.486, 1.0, 0.392))

func _process(delta: float) -> void:
	print(timer.time_left)

func in_area(node2d : Node2D):
	if node2d is FreezeableObject:
		node2d.freeze()
		freezeable_objects_in_area.append(node2d)
		print(freezeable_objects_in_area)

func unfreeze():
	for obj in freezeable_objects_in_area:
		obj.unfreeze()
	self.queue_free()

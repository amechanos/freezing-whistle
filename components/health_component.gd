extends Node2D
class_name HealthComponent

<<<<<<< Updated upstream
@export var max_health : float = 100
var current_health : float = max_health
=======
#this script communicates through signals

@export var max_health : int = 100
@export var random_health : bool = false
@export var random_health_values : Vector2 = Vector2(20, 50)

var current_health : float
>>>>>>> Stashed changes

signal damaged
signal healed
signal health_changed(new_amount:float, new_max_health:float)
signal died

func _ready() -> void:
	call_deferred('set_up') #waiting for node to be fully made before set up

func set_up():
	if random_health:
		var _max_health = randf_range(random_health_values.x, random_health_values.y)
		max_health = floor(_max_health / 10.0) * 10
		current_health = max_health
		health_changed.emit(current_health, max_health)
		print(max_health)
	else:
		current_health = max_health

func take_damage(damage_data : DamageData):
	current_health = clampf(current_health - damage_data.amount, 0, max_health)
	
	if current_health <= 0:
		died.emit()
	else:
		damaged.emit()
	
	health_changed.emit(current_health, max_health)

func heal(amount : float) -> void:
	current_health = clampf(current_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(current_health, max_health)

func set_health(amount : float) -> void:
	current_health = amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func simple_take_damage(amount : float) -> void:
	current_health = clampf(current_health - amount, 0, max_health)
	
	if current_health <= 0:
		died.emit()
	else:
		damaged.emit()
	
	health_changed.emit(current_health, max_health)

extends Node2D
class_name HealthComponent

@export var max_health : int = 100
@export var min_health : int = 100
@export var rand_health : bool = true
var current_health : float = max_health

signal damaged
signal healed
signal health_changed(new_amount:float, new_max_health:float)
signal died

func _ready() -> void:
	call_deferred('set_up')

func set_up():
	if rand_health:
		set_health(round(randi_range(min_health, max_health)))
	else:
		current_health = amProps.health
	
	health_changed.emit(current_health, max_health)

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

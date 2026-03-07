extends Node2D
class_name HealthComponent

@export var max_health : float = 100
var current_health : float = max_health

signal damaged
signal healed
signal health_changed(new_amount:float, new_max_health:float)
signal died

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

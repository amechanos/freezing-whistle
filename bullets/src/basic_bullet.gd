extends Node2D
class_name BasicBullet

@export var speed : float = 50
@export var damage : float = amProps.bullet_damage

func _process(delta: float) -> void:
	move_local_x(delta * speed * 10)

func body_entered(body : Node2D):
	if body.has_node("HealthComponent"):
		var health_component : HealthComponent = body.health_component
		var damage_data : DamageData = DamageData.new()
		damage_data.amount = damage
		damage_data.hit_direction = -global_rotation
		health_component.take_damage(damage_data)
		
		if body.healthBar and body.health_component:
			body.healthBar.text = "Health: " + str(int(body.health_component.current_health))
			
		queue_free()

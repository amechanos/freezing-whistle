extends FreezeableObject
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var target : Node2D = get_tree().get_first_node_in_group('player')
@export var speed : float = 10
@export var damage : float = 100

func _ready() -> void:
	add_to_group('enemies')

func _process(delta: float) -> void:
	if is_frozen:
		return
	look_at(target.global_position)
	move_local_x(delta * speed * 10)

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		if target.has_node("HealthComponent"):
			var new_damage_data : DamageData = DamageData.new()
			var hc : HealthComponent = target.health_component
			hc.take_damage(new_damage_data)
		
		kill()

func kill():
	queue_free()

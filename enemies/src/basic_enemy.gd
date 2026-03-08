extends FreezeableObject
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var healthBar = $HP
@onready var target : Node2D = get_tree().get_first_node_in_group('player')

@onready var sprite = $Sprite2D 

@export var speed : float = 10
@export var damage : float = randi_range(25,75)

func _ready() -> void:
	add_to_group('enemies')
	healthBar.text = "Health: " + str(int(health_component.current_health))

func _process(delta: float) -> void:
	if is_frozen:
		return
	
	var direction = global_position.direction_to(target.global_position)
	
	sprite.look_at(target.global_position)
	global_position += direction * speed * 10 * delta

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		if target.has_node("HealthComponent"):
			var new_damage_data : DamageData = DamageData.new()
			var hc : HealthComponent = target.health_component
			hc.take_damage(new_damage_data)

func kill():
	Global.enemy_killed()
	queue_free()

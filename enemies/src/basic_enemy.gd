extends FreezeableObject
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var healthBar = $HP
@onready var target : Node2D = get_tree().get_first_node_in_group('player')

@onready var sprite = $Sprite2D 

var speed : float = 10
@export var min_speed : float = 10
@export var max_speed : float = 15

@export var attack_range : float = 120
@export var attack_time : float = 0.75
@export var stopping_dist : float = 100

@export var min_damage : int = 25
@export var max_damage : int = 40
var damage : int 

var attacking : bool = false

func _ready() -> void:
	call_deferred("set_up")

func set_up():
	add_to_group('enemies')
	speed = randf_range(min_speed, max_speed)
	healthBar.text = "Health: " + str(int(health_component.current_health))
	damage = randi_range(min_damage, max_damage)

func _process(delta: float) -> void:
	if is_frozen or !target:
		return
	
	var direction = global_position.direction_to(target.global_position)
	
	sprite.look_at(target.global_position)
	global_position += direction * speed * 10 * delta

func update_health_bar(cur_health:float, _mhp:float):
	healthBar.text = "Health:" + str(cur_health)

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		if target.has_node("HealthComponent"):
			var new_damage_data : DamageData = DamageData.new()
			var hc : HealthComponent = target.health_component
			new_damage_data.amount = damage
			hc.take_damage(new_damage_data)
			print(hc.current_health)

func attack():
	attacking = true
	await get_tree().create_timer(attack_time).timeout
	
	if !target_in_range():
		return
	
	#check for HC and if we are still in range
	if target.has_node("HealthComponent") and target_in_range():
		var new_damage_data : DamageData = DamageData.new()
		new_damage_data.amount = damage
		
		var hc : HealthComponent = target.get_node_or_null("HealthComponent")
		if hc:
			hc.take_damage(new_damage_data)

func target_in_range() -> bool:
	if global_position.distance_to(target.global_position) <= attack_range:
		return true
	return false

func kill():
	Global.enemy_killed()
	queue_free()

extends FreezeableObject
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var healthBar = $HP
@onready var sprite : Sprite2D = $Sprite2D

var target : Node2D

var speed : float

@export var min_speed : float = 10
@export var max_speed : float = 15

@export var attack_range : float = 150
@export var attack_time : float = 0.75
@export var stopping_dist : float = 100

@export var min_damage : int = 25
@export var max_damage : int = 40

@export var score_min : int = 10
@export var score_max : int = 25

var damage : int
var attacking : bool = false

func _ready() -> void:
	call_deferred("set_up")

func set_up():
	add_to_group("enemies")
	
	target = get_tree().get_first_node_in_group("player")
	
	speed = randf_range(min_speed, max_speed)
	damage = randi_range(min_damage, max_damage)
	
	health_component.health_changed.connect(update_health_bar)
	update_health_bar(health_component.current_health, health_component.max_health)


func _physics_process(delta: float) -> void:
	if is_frozen or !target:
		return
	
	move_character(delta)


func move_character(delta):
	var direction = global_position.direction_to(target.global_position)
	var dist = global_position.distance_to(target.global_position)
	
	sprite.rotation = direction.angle()
	
	if dist > stopping_dist:
		global_position += direction * speed * delta * 10
	
	if dist <= attack_range and !attacking:
		attack()

func update_health_bar(cur_health:float, _mhp:float):
	healthBar.text = "Health: " + str(int(cur_health))

func attack():
	attacking = true
	
	await get_tree().create_timer(attack_time).timeout
	
	if !target_in_range():
		attacking = false
		return
	
	var hc : HealthComponent = target.get_node_or_null("HealthComponent")

	if hc:
		var new_damage_data := DamageData.new()
		new_damage_data.amount = damage
		hc.take_damage(new_damage_data)

	attacking = false


func target_in_range() -> bool:
	return global_position.distance_to(target.global_position) <= attack_range

func kill():
	Global.enemy_killed(score_min, score_max)
	queue_free()

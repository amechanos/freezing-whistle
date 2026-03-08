extends FreezeableObject
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
<<<<<<< Updated upstream
@onready var target : Node2D = get_tree().get_first_node_in_group('player')
@export var speed : float = 10
@export var damage : float = 100

func _ready() -> void:
	add_to_group('enemies')
=======
@onready var healthBar : ProgressBar = $HP
@onready var target : Node2D = get_tree().get_first_node_in_group('player')

@onready var graphics = $PaperDoll 

@export var speed : float = 100
@export var damage : float
@export var attack_range : float = 120
@export var attack_time : float = 0.75
@export var stopping_dist : float = 100

var attacking : bool = false

func _ready() -> void:
	add_to_group('enemies')
	target = get_tree().get_first_node_in_group('player')
>>>>>>> Stashed changes

func _physics_process(delta: float) -> void:
	if is_frozen or !target:
		return
<<<<<<< Updated upstream
	look_at(target.global_position)
	move_local_x(delta * speed * 10)
=======
	
	move_character(delta)

func update_health_bar(val:float, max_val:float):
	healthBar.value = val
	healthBar.max_value = max_val

func move_character(delta):
	var direction = global_position.direction_to(target.global_position)
	
	if global_position.distance_to(target.global_position) > stopping_dist:
		graphics.rotation = direction.angle()
		global_position += direction * speed * delta
	
	if target_in_range() and !attacking:
		$AnimationPlayer.play("attack")
>>>>>>> Stashed changes

#this is called from attack animation
func attack():
	attacking = true
	#check for HC and if we are still in range
	if target.has_node("HealthComponent") and target_in_range():
		var new_damage_data : DamageData = DamageData.new()
		new_damage_data.amount = damage
		
		var hc : HealthComponent = target.get_node_or_null("HealthComponent")
		if hc:
			hc.take_damage(new_damage_data)
<<<<<<< Updated upstream
		
		kill()

func kill():
=======
			print(hc.current_health)
	
	if !target_in_range():
		$AnimationPlayer.play("walk")
		attacking = false

func freeze():
	super()
	$AnimationPlayer.stop(true)

func unfreeze():
	super()
	$AnimationPlayer.play("walk")

func target_in_range() -> bool:
	if global_position.distance_to(target.global_position) <= attack_range:
		return true
	return false

func kill():
	Global.enemy_died(randi_range(1, 25))
>>>>>>> Stashed changes
	queue_free()

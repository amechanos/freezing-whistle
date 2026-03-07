extends CharacterBody2D

@onready var weapon_holder : WeaponHolder = $WeaponHolder
@onready var health_component : HealthComponent = $HealthComponent
@onready var freeze_component : FreezeComponent = $FreezeComponent
@onready var sprite : Sprite2D = $Sprite2D

@export var max_speed : float = 200.0
@export var acceleration : float = 800.0
@export var friction : float = 900.0

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward( input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward( Vector2.ZERO, friction * delta)
	
	if Input.is_action_pressed("fire"):
		weapon_holder.shoot()
	
	if Input.is_action_just_pressed("freeze"):
		freeze_component.create_freeze()
	
	look_at(get_global_mouse_position())
	
	move_and_slide()
	
	global_position.x = clampf(global_position.x, 0, 1920)
	global_position.y = clampf(global_position.y, 0, 1080)

func update_graphics(weapon_data:WeaponData):
	sprite.texture = weapon_data.player_texture

func kill():
	pass #end of game trigger

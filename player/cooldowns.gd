extends Camera2D

@onready var volley_cooldown_bar: TextureProgressBar = $UI/basebar/volley/TextureProgressBar
@onready var freeze_cooldown_bar: TextureProgressBar = $UI/basebar/freeze/TextureProgressBar

func _ready():
	Global.updateUI()
	var weapon_holder = owner.find_child("WeaponHolder")
	if weapon_holder:
		weapon_holder.ability_cooldown_started.connect(_on_ability_cooldown_started)
		print("Found ", weapon_holder)
	else:
		print("Weapon component not found")
		
	var freeze_component = owner.find_child("FreezeComponent")
	if freeze_component:
		freeze_component.ability_cooldown_started.connect(_on_ability_cooldown_started)
		print("Found ", freeze_component)
	else:
		print("Freeze component not found")
		
	volley_cooldown_bar.value = 0
	freeze_cooldown_bar.value = 0

func _on_ability_cooldown_started(ability_name: String, duration: float) -> void:
	var bar_to_update: TextureProgressBar
	
	match ability_name:
		"volley":
			bar_to_update = volley_cooldown_bar
		"freeze":
			bar_to_update = freeze_cooldown_bar
			
	if bar_to_update:
		bar_to_update.max_value = duration
		bar_to_update.value = duration
		
		var tween = create_tween()
		tween.tween_property(bar_to_update, "value", 0.0, duration)

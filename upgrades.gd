extends Control

var upgrade_data = {
	"health": {"category": "gun", "cost": 25, "level" : 1, "prop_name": "health", "cost_multiplier": 1.25, "stat_increase": 25},
	"damage_gun": {"category": "gun", "cost": 20, "level": 1, "prop_name": "bullet_damage", "cost_multiplier": 1.6, "stat_increase": 5.0},
	"firerate_gun": {"category": "gun", "cost": 25, "level": 1, "prop_name": "fire_rate", "cost_multiplier": 1.4, "stat_increase": -0.1}, 
	"cooldown_freeze": {"category": "freeze", "cost": 30, "level": 1, "prop_name": "freezeCooldown", "cost_multiplier": 1.5, "stat_increase": -0.5},
	"duration_freeze": {"category": "freeze", "cost": 30, "level": 1, "prop_name": "freezeDur", "cost_multiplier": 1.5, "stat_increase": 0.5},
	"size_freeze": {"category": "freeze", "cost": 30, "level": 1, "prop_name": "freezeSize", "cost_multiplier": 1.5, "stat_increase": 10.0},
	"cooldown_burst": {"category": "burst", "cost": 40, "level": 1, "prop_name": "burst_cooldown", "cost_multiplier": 1.5, "stat_increase": -0.5},
	"duration_burst": {"category": "burst", "cost": 40, "level": 1, "prop_name": "burst_duration", "cost_multiplier": 1.5, "stat_increase": 0.5}
}

func _ready() -> void:
	for key in upgrade_data.keys():
		var cat = upgrade_data[key]["category"]
		var button : Button = get_node("VBoxContainer/" + cat + "/" + key + "/Button")
		
		# Bind the specific upgrade key to the button press
		button.pressed.connect(_on_buy_button_pressed.bind(key))
		
	update_all_ui()

func update_all_ui() -> void:
	$balance.text = "Balance: $" + str(Global.currency)
	for key in upgrade_data.keys():
		var data = upgrade_data[key]
		var cat = data["category"]
		var prop = data["prop_name"]
		
		var label : Label = get_node("VBoxContainer/" + cat + "/" + key + "/Label")
		var button : Button = get_node("VBoxContainer/" + cat + "/" + key + "/Button")
		
		# 1. Dynamically read the current stat directly from amProps
		var current_stat = amProps.get(prop)
		
		# 2. Update Label to show the true baseline value
		label.text = "Lvl " + str(data["level"]) + " (Stat: " + str(current_stat) + ")"
		
		# 3. Update Button and Check Affordability 
		button.text = "Buy: $" + str(data["cost"])
		button.disabled = Global.currency < data["cost"]

func _on_buy_button_pressed(upgrade_key: String) -> void:
	var data = upgrade_data[upgrade_key]
	var prop = data["prop_name"]
	
	if Global.currency >= data["cost"]:
		# Deduct currency
		Global.currency -= data["cost"]
		
		# Get the current value from amProps, apply the math, and set it back
		var current_stat = amProps.get(prop)
		amProps.set(prop, current_stat + data["stat_increase"])
		
		# Update internal tracking
		data["level"] += 1
		data["cost"] = int(data["cost"] * data["cost_multiplier"])
		
		# Refresh UI to show the new stat and new cost
		update_all_ui()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://test.tscn")

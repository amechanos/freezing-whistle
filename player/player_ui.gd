extends CanvasLayer
class_name PlayerUI

#This is pretty self explainitory just waiting for signals to update UI
#note i need to actually learn ui dev

func _ready() -> void:
	Global.currency_updated.connect(_update_currency)
	Global.round_started.connect(on_round_started)
	Global.round_ended.connect(on_round_ended)

func _update_currency(new_amount : int):
	$InGameUI/CoinLabel.text = 'Coins:' + str(new_amount)

func on_round_started(current_round : int):
	$InGameUI/RoundLabel.text = "round\n" + str(current_round)

func update_health_bar(current_health:float, max_health:float):
	$InGameUI/HealthBar.value = current_health
	$InGameUI/HealthBar.max_value = max_health

func on_round_ended():
	$upgrades.visible = true
	$InGameUI.visible = false

func start_next_round() -> void:
	_update_currency(Global.currency) 
	$upgrades.visible = false
	$InGameUI.visible = true
	Global.start_round()

extends Control

func start_game():
	get_tree().change_scene_to_file("res://test.tscn")

func quit():
	get_tree().quit()

func toggle_sounds(b : bool):
	AudioServer.set_bus_mute(0, !b)

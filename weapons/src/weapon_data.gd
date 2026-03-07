extends Resource
class_name WeaponData

@export var player_texture : Texture2D
@export var bullet_scene : PackedScene

@export_group("Firing Properties")
@export var bullet_count : int = 1
@export_range(0, 1) var arc : float = 0
@export_range(0, 20) var fire_rate : float = 2

@export_group("Burst Properties")
@export var burst_size : int = 1
@export_range(0, 1) var time_tween_shots : float = 0.2

extends Resource
class_name WeaponData

@export var player_texture : Texture2D
@export var bullet_scene : PackedScene

@export_group("Firing Properties")
@export var bullet_count : int = 1
@export_range(0, 1) var arc : float = 0
@export_range(0, 20) var fire_rate : float = 1.5

@export_group("Volley Properties")
@export var burst_size : int = 25
@export var burst_cooldown: int = 15
@export_range(0, 1) var time_tween_shots : float = 0.25

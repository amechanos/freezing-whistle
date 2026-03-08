extends Node

# Weapon ability
@export var bullet_count : int = 1
@export var bullet_damage : float = 10
@export_range(0, 1) var arc : float = 0
@export_range(0, 20) var fire_rate : float = 1.5

@export var burst_duration : int = 2
@export var burst_cooldown: int = 10
@export_range(0, 1) var time_between_shots : float = 0.25

# Freeze ability
@export var freezeSize : float = 100
@export var freezeCooldown : float = 10
@export var freezeDur : float = 2

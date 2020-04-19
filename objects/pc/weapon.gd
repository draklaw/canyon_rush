extends Node2D

class_name Weapon


export var damage: float = 10
export var ammo_capacity: int = 0
export var reload_delay: float = 1
export var burst: int = 1
export var shot_count: int = 1
export var shot_delay: float = 0.2
export var scattering: float = 0
export var shot_speed: float = 1024
export var shot_speed_var: float = 0

export var shot: PackedScene


onready var shot_layer: Node = owner.get_node("/root/world/shots")

var shooting: bool = false
var time_before_next_shot: float = 0
var reload_time_remaining: float = 0
var ammo_count: int = 0
var shots_remaining: int = 0


func _ready() -> void:
	ammo_count = ammo_capacity
	shots_remaining = burst


func start_shooting():
	shooting = true
	time_before_next_shot = max(time_before_next_shot, 0)


func stop_shooting():
	shooting = false
	shots_remaining = burst


func _physics_process(delta: float) -> void:
	time_before_next_shot -= delta
	reload_time_remaining -= delta

	if (
		not shooting
		or time_before_next_shot > 0
		or reload_time_remaining > 0
		or (ammo_count == 0 and ammo_capacity != 0)
		or (shots_remaining == 0 and burst != 0)
	):
		return

	shoot_once()
	ammo_count -= 1
	shots_remaining -= 1
	time_before_next_shot += shot_delay


func shoot_once():
	for i in range(shot_count):
		var shot = _spawn_shot()
		shot.damage = damage
		shot.velocity = shot_speed * (1 + (randf() - .5) * shot_speed_var)
		shot.position = to_global(position)
		shot.rotation = owner.rotation + (randf() - .5) * deg2rad(scattering)
		shot_layer.add_child(shot)

	$"../shot_stream".play()


func reload():
	if reload_time_remaining <= 0 and ammo_count != ammo_capacity:
		ammo_count = ammo_capacity
		reload_time_remaining = reload_delay
		shots_remaining = burst


func _spawn_shot():
	return shot.instance()

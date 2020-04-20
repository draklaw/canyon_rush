extends Node2D

class_name Weapon


export var weapon_index: int = 0
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


signal ammo_count_changed


func _ready() -> void:
	ammo_count = ammo_capacity
	shots_remaining = burst


func start_shooting():
	if not shooting:
		shooting = true
		time_before_next_shot = max(time_before_next_shot, 0)


func stop_shooting():
	if shooting:
		shooting = false
		shots_remaining = burst


func _physics_process(delta: float) -> void:
	var not_reloaded_yet = reload_time_remaining > 0

	time_before_next_shot -= delta
	reload_time_remaining -= delta

	if not_reloaded_yet and reload_time_remaining <= 0:
		ammo_count = ammo_capacity
		time_before_next_shot = 0
		emit_signal("ammo_count_changed", ammo_count)

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

	emit_signal("ammo_count_changed", ammo_count)


func shoot_once():
	for _i in range(shot_count):
		var shot = _spawn_shot()
		shot.damage = damage
		shot.velocity = shot_speed * (1 + (randf() - .5) * shot_speed_var)
		shot.position = to_global(position)
		shot.rotation = -PI/2 + $"..".rotation + (randf() - .5) * deg2rad(scattering)
		shot_layer.add_child(shot)

	$"../../shot_stream".play()


func reload():
	if reload_time_remaining <= 0 and ammo_count != ammo_capacity:
		#ammo_count = ammo_capacity
		reload_time_remaining = reload_delay
		shots_remaining = burst


func _spawn_shot():
	return shot.instance()

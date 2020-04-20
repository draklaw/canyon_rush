extends Area2D

class_name FlockSpawn


export(Array, Resource) var spawn_table = []

export var spawn_delay: float = 1
export var evolution_factor: float = 0


onready var shape: CollisionShape2D = $spawn_shape
onready var alien_layer: Node = $"/root/world/aliens"

var spawn_progress = []
var next_spawn = []

var utils = preload("res://utils.gd").new()

func _ready() -> void:
	var count = spawn_table.size()

	spawn_progress.resize(count)
	next_spawn.resize(count)

	for i in range(count):
		spawn_progress[i] = 0
		next_spawn[i] = rand_range(0.5, 1.5)


func _process(delta: float) -> void:
	if evolution_factor < 1:
		evolution_factor += delta/480
	else:
		evolution_factor = 1

	for i in range(spawn_table.size()):
		var info = spawn_table[i]
		var delay = lerp(info.delay_start, info.delay_end, evolution_factor)

		spawn_progress[i] += delta
		if spawn_progress[i] >= delay * next_spawn[i]:
			spawn(info.alien, info.rand_flock_size())

			spawn_progress[i] = 0
			next_spawn[i] = rand_range(0.5, 1.5)


func spawn(alien_scene, flock_size) -> void:
	var pos = shape.position
	var extent = shape.shape.extents

	var leader_pos = Vector2(
		rand_range(pos.x - extent.x, pos.x + extent.x),
		rand_range(pos.y - extent.y, pos.y + extent.y)
	)

	var separation: float = 48
	var randomness: float = 16
	var x: float = 0
	var y: float = 0
	for _i in range(flock_size):
		var offset = Vector2(x * separation, y * separation - x * separation / 2.0)
		offset += Vector2(
			rand_range(-randomness, randomness),
			rand_range(-randomness, randomness)
		)

		var alien: Alien = alien_scene.instance()
		alien.position = leader_pos + offset
		alien.velocity = Vector2(-alien.max_speed, 0)

		alien_layer.add_child(alien)

		if x == y:
			x += 1
			y = 0
		else:
			y += 1

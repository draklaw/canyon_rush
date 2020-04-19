extends Area2D


export var mob: PackedScene

export var spawn_delay: float = 1
export var evolution_factor: float = 0


onready var shape: CollisionShape2D = $spawn_shape
var remaining_time: float = 0

var utils = preload("res://utils.gd").new()
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	remaining_time = spawn_delay
	rng.randomize()

func _process(delta: float) -> void:
	if evolution_factor < 1:
		evolution_factor += delta/600
	else:
		evolution_factor = 1
	remaining_time -= delta
	while remaining_time <= 0:
		spawn()
		remaining_time += spawn_delay

func spawn() -> void:
	var pos = shape.position
	var extent = shape.shape.extents

	var mob_pos = Vector2(
		rng.randf_range(pos.x - extent.x, pos.x + extent.x),
		rng.randf_range(pos.y - extent.y, pos.y + extent.y)
	)

	var new_mob: Mob = mob.instance()
	new_mob.position = mob_pos
	var mob_crew = utils.interpol(Mob.trash, Mob.leet, evolution_factor)
	var mobroll = randf() * utils.sum(mob_crew)
	var mobtype = 0
	while mobroll >= 0:
		mobroll -= mob_crew[mobtype]
		mobtype += 1
	new_mob.set_mobtype(mobtype-1)
	add_child(new_mob)

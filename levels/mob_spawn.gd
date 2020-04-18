extends Area2D


export var mob: PackedScene

export var spawn_delay: float = 1


onready var shape: CollisionShape2D = $spawn_shape
var remaining_time: float = 0

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	remaining_time = spawn_delay
	rng.randomize()


func _process(delta: float) -> void:
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

	var new_mob = mob.instance()
	new_mob.position = mob_pos
	add_child(new_mob)

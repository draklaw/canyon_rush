extends Area2D


enum { LAZOR, SPIT }
export var type = LAZOR
export var velocity: float = 1024
export var acceleration: float = 0
export var damage: float = 10
export var max_range: float = 3000


var distance_traveled: float = 0


func _ready() -> void:
	var err = connect("body_entered", self, "on_hit_body")
	assert(err == OK)
	add_to_group("shoots")


func _physics_process(delta: float) -> void:
	distance_traveled += delta * velocity
	if distance_traveled > max_range:
		queue_free()
		return

	var speed = velocity + (distance_traveled / velocity) * acceleration
	var dir = transform.basis_xform(Vector2(1, 0))
	position += dir * (delta * speed)


func on_hit_body(body: Node) -> void:
	if body is Character:
		if body.alive:
			body.call("take_damage", damage)
		else:
			return
	queue_free()

extends Area2D


enum { LAZOR, SPIT }
export var type = LAZOR
export var velocity: float = 1024
export var damage: float = 10


func _ready() -> void:
	var err = connect("body_entered", self, "on_hit_body")
	assert(err == OK)
	add_to_group("shoots")


func _physics_process(delta: float) -> void:
	var dir = transform.basis_xform(Vector2(1, 0))
	position += dir * (delta * velocity)


func on_hit_body(body: Node) -> void:
	if body is Character:
		body.call("take_damage", damage)
	queue_free()

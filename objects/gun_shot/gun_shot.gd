extends Area2D


export var velocity: float = 1024
export var damage: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "on_hit_body")


func _physics_process(delta: float) -> void:
	var dir = transform.basis_xform(Vector2(1, 0))
	position += dir * (delta * velocity)


func on_hit_body(body: Node) -> void:
	if body.has_method("take_damage"):
		body.call("take_damage", damage)
	queue_free()

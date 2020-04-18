extends KinematicBody2D


export var speed: float = 256


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var offset = Vector2()

	if Input.is_action_pressed("p1_left"):
		offset.x -= 1
	if Input.is_action_pressed("p1_right"):
		offset.x += 1
	if Input.is_action_pressed("p1_up"):
		offset.y -= 1
	if Input.is_action_pressed("p1_down"):
		offset.y += 1

	offset = offset.normalized() * speed

	move_and_slide(offset)


extends KinematicBody2D


export var speed: float = 256


onready var shot_layer = get_node("/root/world")
var gun_shot = preload("res://objects/gun_shot/gun_shot.tscn")


func _ready() -> void:
	pass


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

	var target = get_viewport().get_mouse_position()
	var view_vec = (target - position).normalized()
	var view_vec_orth = Vector2(view_vec.y, -view_vec.x)

	transform = Transform2D(view_vec_orth, -view_vec, position)

	if Input.is_action_just_pressed("p1_shoot"):
		var shot = gun_shot.instance()
		shot.position = position
		shot.look_at(target)
		shot_layer.add_child(shot)

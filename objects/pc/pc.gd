extends KinematicBody2D


export var max_hp: float = 100
export var hp: float = 100

export var recovery_time: float = 0

export var speed: float = 256


var remaining_recovery_time = 0

onready var shot_layer = get_node("/root/world")
var gun_shot = preload("res://objects/gun_shot/gun_shot.tscn")


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	### MOVEMENT

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

	### ORIENTATION

	var target = get_viewport().get_mouse_position()
	var view_vec = (target - position).normalized()
	var view_vec_orth = Vector2(view_vec.y, -view_vec.x)

	transform = Transform2D(view_vec_orth, -view_vec, position)

	### WEAPONS

	if Input.is_action_just_pressed("p1_shoot"):
		var shot = gun_shot.instance()
		shot.position = position
		shot.look_at(target)
		shot_layer.add_child(shot)

	### DAMAGE & RECOVERY

	remaining_recovery_time -= delta

	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		var damage_on_hit = collider.get("damage_on_hit")
		if damage_on_hit:
			take_damage(damage_on_hit)


func take_damage(damage: float):
	if damage <= 0 or remaining_recovery_time > 0:
		return

	hp -= damage
	print("take_damage %f: %f" % [damage, hp])
	remaining_recovery_time = recovery_time

	if hp <= 0:
		die()


func die():
	queue_free()

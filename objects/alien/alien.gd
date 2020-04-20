extends Character

class_name Alien

enum Behavior {
	WANDER,
	MOVE_TO,
	ATTACK,
	RANGED_ATTACK,
}


export var mass: float = 1
export var max_speed: float = 192
export var max_force: float = 512
export var max_rotation: float = 6
export var velocity: Vector2 = Vector2()

export var seek_radius: float = 1000
export var mele_damage: float = 10
export var mele_attack_time: float = 0.8

export var ranged_damage: float = 0
export var ranged_attack_time: float = 2
export var ranged_engage_dist: float = 750
export var ranged_shot_dist: float = 1000
export var ranged_shot: PackedScene = preload("res://objects/gun_shot/alien_shot.tscn")

export var neighbor_radius: float = 100
export var separation: float = 100
export var cohesion: float = 0.1
export var alignement: float = 0.1

export var update_every: int = 10



var behavior: int = Behavior.WANDER
var target_path: NodePath = @""

var frame_counter: int = 0
var neighbors := []

onready var players_node = $"/root/world/players"

onready var rotate_node = $rotate
onready var sprite = $rotate/sprite
onready var shape = $shape
onready var attack_ray = $rotate/attack_ray


func _ready() -> void:
	frame_counter = randi() % update_every


func _physics_process(delta: float) -> void:
	frame_counter = (frame_counter + 1) % update_every
	if frame_counter == 0:
		update_neighbors()

	match behavior:
		Behavior.WANDER:
			process_wander(delta)
		Behavior.MOVE_TO:
			process_move_to(delta)
		Behavior.ATTACK:
			process_attack(delta)
		Behavior.RANGED_ATTACK:
			process_ranged_attack(delta)


func process_wander(delta: float) -> void:
	behavior = Behavior.WANDER

	target_path = look_for_target()
	if target_path:
		process_move_to(delta)
		return

	var drift_vec = Vector2(-1, 0)

	steer_toward(delta, position + drift_vec * 100)


func process_move_to(delta: float) -> void:
	behavior = Behavior.MOVE_TO

	var target = get_node(target_path)
	if not target:
		process_wander(delta)
		return

	if ranged_damage and position.distance_to(target.position) < ranged_engage_dist:
		process_ranged_attack(delta)
		return


	if can_attack(target):
		process_attack(delta)
		return

	steer_toward(delta, target.position)


func process_attack(delta: float) -> void:
	behavior = Behavior.ATTACK

	var target = get_node(target_path)
	if not target:
		process_wander(delta)
		return

	if sprite.animation != "attack":
		rotate_node.look_at(target.position)
		sprite.play("attack")
		sprite.speed_scale = 1 / mele_attack_time
		sprite.connect("animation_finished", self, "end_attack", [], CONNECT_ONESHOT)
		sprite.connect("frame_changed", self, "on_attack_frame")


func process_ranged_attack(delta: float) -> void:
	behavior = Behavior.RANGED_ATTACK

	var target = get_node(target_path)
	if not target:
		process_wander(delta)
		return

	if sprite.animation != "attack":
		rotate_node.look_at(target.position)
		sprite.speed_scale = 1 / ranged_attack_time
		sprite.play("attack")
		sprite.connect("animation_finished", self, "end_attack", [], CONNECT_ONESHOT)
		sprite.connect("frame_changed", self, "on_ranged_attack_frame")


func on_attack_frame():
	if sprite.frame != 1:
		return

	var target = get_node(target_path)
	if target and sprite.frame == 1 and can_attack(target):
		target.take_damage(mele_damage)

	sprite.disconnect("frame_changed", self, "on_attack_frame")


func on_ranged_attack_frame():
	if sprite.frame != 1:
		return

	var shot_layer = $"/root/world/shots"
	if shot_layer:
		var shot = ranged_shot.instance()
		shot.max_range = ranged_shot_dist
		shot.transform = attack_ray.get_global_transform()
		shot_layer.add_child(shot)

	sprite.disconnect("frame_changed", self, "on_ranged_attack_frame")


func end_attack():
	behavior = Behavior.MOVE_TO
	sprite.animation = "walk"
	sprite.speed_scale = 1
	sprite.stop()


func steer_toward(delta: float, target: Vector2) -> void:
	var desired_vel: Vector2 = position.direction_to(target) * max_speed
	var steering_direction: Vector2 = desired_vel - velocity

	var count = 0
	var sep_steer = Vector2()
	var nb_sum = Vector2()
	var vel_sum = Vector2()
	for nb_path in neighbors:
		var nb = get_node(nb_path)
		if not nb:
			continue

		count += 1
		var offset = nb.position - position
		var dist = max(offset.length() - shape.shape.radius - nb.shape.shape.radius + 1, 1)
		sep_steer -= offset / (dist * dist)
		nb_sum += offset
		vel_sum += nb.velocity

	if count:
		steering_direction += sep_steer * (separation / count)
		steering_direction += nb_sum * (cohesion / count)
		steering_direction += (vel_sum / count - velocity) * (alignement / max_speed)


	var steering_force: Vector2 = steering_direction.clamped(max_force * delta)
	var acceleration: Vector2 = steering_force / mass
	velocity = (velocity + acceleration).clamped(max_speed)

	var real_vel = move_and_slide(velocity)
	velocity = real_vel
	rotate_node.look_at(position + velocity)

	sprite.play("walk")
	if real_vel.length() < max_speed / 4:
		sprite.stop()


func can_attack(target: Node2D):
	attack_ray.force_raycast_update()
	return attack_ray.get_collider() == target


func update_neighbors():
	neighbors.clear()
	for nb in $"..".get_children():
		if nb != self and position.distance_to(nb.position) < neighbor_radius:
			neighbors.append(nb.get_path())


func look_for_target():
	var candidates = []

	if has_node("/root/world/human"):
		candidates.append(get_node("/root/world/human"))

	for node in players_node.get_children():
		candidates.append(node)

	var choice = null
	var dist = seek_radius
	for candidate in candidates:
		var d = position.distance_to(candidate.position)
		if d < dist:
			choice = candidate
			dist = d

	return choice.get_path() if choice else @""

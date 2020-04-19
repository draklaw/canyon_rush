extends Character


export var speed: float = 256
export var dodge_speed: float = 900
export var dodge_time: float = 0.15
export var dodge_recovery: float = 0.5


onready var gun: Weapon = $gun
onready var machine_gun: Weapon = $machine_gun
onready var shotgun: Weapon = $shotgun

var weapon: Weapon
var remaining_dodge_time: float = 0
var dodge_direction: Vector2


signal weapon_changed


func _ready() -> void:
	var err = connect("took_damage", self, "on_took_damage")
	assert(err == OK)


func _physics_process(delta: float) -> void:
	### MOVEMENT
	remaining_dodge_time -= delta

	var direction = Vector2()

	if Input.is_action_pressed("p1_left"):
		direction.x -= 1
	if Input.is_action_pressed("p1_right"):
		direction.x += 1
	if Input.is_action_pressed("p1_up"):
		direction.y -= 1
	if Input.is_action_pressed("p1_down"):
		direction.y += 1

	direction = direction.normalized()

	if Input.is_action_just_pressed("p1_dodge") and remaining_dodge_time <= -dodge_recovery:
		remaining_dodge_time = dodge_time
		dodge_direction = direction
		weapon.stop_shooting()

	if remaining_dodge_time > 0:
		move_and_slide(dodge_direction * dodge_speed)
	else:
		move_and_slide(direction * speed)

	### ORIENTATION

	var target = get_viewport().get_mouse_position()
	look_at(target)

	### WEAPONS

	if remaining_dodge_time <= 0:
		if Input.is_action_pressed("p1_shoot"):
			weapon.start_shooting()
		else:
			weapon.stop_shooting()

		if Input.is_action_just_pressed("p1_reload"):
			weapon.reload()

	._physics_process(delta)


func set_weapon(weapon_: Weapon):
	weapon = weapon_
	emit_signal("weapon_changed", weapon)


func on_took_damage(_damage):
	$damage_stream.play()

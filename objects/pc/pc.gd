extends Character


export var speed: float = 256


onready var gun: Weapon = $gun
onready var machine_gun: Weapon = $machine_gun
onready var shotgun: Weapon = $shotgun

var weapon: Weapon


signal weapon_changed


func _ready() -> void:
	var err = connect("took_damage", self, "on_took_damage")
	assert(err == OK)


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
	look_at(target)

	### WEAPONS

	if Input.is_action_just_pressed("p1_shoot"):
		weapon.start_shooting()
	elif Input.is_action_just_released("p1_shoot"):
		weapon.stop_shooting()

	if Input.is_action_just_pressed("p1_reload"):
		weapon.reload()

	._physics_process(delta)


func set_weapon(weapon_: Weapon):
	weapon = weapon_
	emit_signal("weapon_changed", weapon)


func on_took_damage(_damage):
	$damage_stream.play()

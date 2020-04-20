extends Character

class_name PlayerCharacter


enum WeaponType {
	SHOTGUN,
	MACHINE_GUN,
	ROCKET_LAUNCHER,
	RAILGUN,
}


export var player_index: int = 0

export var speed: float = 256
export var dodge_speed: float = 900
export var dodge_time: float = 0.15
export var dodge_recovery: float = 0.5


onready var machine_gun: Weapon = $ship/machine_gun
onready var shotgun: Weapon = $ship/shotgun
onready var weapons = [shotgun, machine_gun]

var controller = null
var weapon_index = WeaponType.MACHINE_GUN setget set_weapon_index
var remaining_dodge_time: float = 0
var dodge_direction: Vector2


signal weapon_changed


func _ready() -> void:
	if not controller:
		controller = PlayerController.new()
		controller.setup(get_viewport(), self)

	var err = connect("took_damage", self, "on_took_damage")
	assert(err == OK)

	err = connect("dying", self, "on_dying")
	assert(err == OK)

func _physics_process(delta: float) -> void:
	### MOVEMENT
	remaining_dodge_time -= delta

	var direction = controller.get_move_direction()

	if controller.is_dodge_just_pressed() and remaining_dodge_time <= -dodge_recovery:
		remaining_dodge_time = dodge_time
		dodge_direction = direction
		get_active_weapon().stop_shooting()

	if remaining_dodge_time > 0:
		# warning-ignore:return_value_discarded
		move_and_slide(dodge_direction * dodge_speed)
	else:
		# warning-ignore:return_value_discarded
		move_and_slide(direction * speed)

	### ORIENTATION

	$ship.rotation = PI/2 + controller.get_look_direction().angle()

	### WEAPONS

	if remaining_dodge_time <= 0:
		if controller.is_shoot_pressed():
			get_active_weapon().start_shooting()
		else:
			get_active_weapon().stop_shooting()

		if controller.is_reload_just_pressed():
			get_active_weapon().reload()

	if controller.is_next_weapon_just_pressed():
		set_weapon_index((weapon_index + 1) % weapons.size())
	if controller.is_prev_weapon_just_pressed():
		set_weapon_index((weapon_index - 1 + weapons.size()) % weapons.size())

	._physics_process(delta)


func get_active_weapon() -> Weapon:
	return weapons[weapon_index]


func set_weapon_index(weapon_index_: int):
	get_active_weapon().stop_shooting()
	weapon_index = weapon_index_
	emit_signal("weapon_changed", player_index, get_active_weapon())


func on_took_damage(_self, _damage):
	$damage_stream.play()

func on_dying():
	var node = $ship.duplicate(0)
	node.animation = "ded"
	node.transform = $ship.get_global_transform()
	$"../../..".add_child_below_node(self, node)

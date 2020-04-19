extends Object

class_name PlayerController


enum Action {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	LOOK_LEFT,
	LOOK_RIGHT,
	LOOK_UP,
	LOOK_DOWN,
	SHOOT,
	DODGE,
	RELOAD,
	NEXT_WEAPON,
	PREV_WEAPON,
}


var viewport: Viewport
var pc: Node
var gamepad_index: int = -1
var gamepad_id: int
var action_names = []
var look_direction := Vector2(1, 0)


const action_suffixes := [
	"left",
	"right",
	"up",
	"down",
	"look_left",
	"look_right",
	"look_up",
	"look_down",
	"shoot",
	"dodge",
	"reload",
	"next_weapon",
	"prev_weapon",
]


func setup(viewport_: Viewport, pc_: Node, gamepad_index_: int = -1):
	viewport = viewport_
	pc = pc_
	gamepad_index = gamepad_index_

	if gamepad_index >= 0:
		var ids = Input.get_connected_joypads()
		if gamepad_index < ids.size():
			gamepad_id = ids[gamepad_index]
		else:
			gamepad_id = -1

	var events = create_default_events()

	var id = "kb" if gamepad_index < 0 else "pad%d_" % gamepad_index
	for act in range(action_suffixes.size()):
		var act_name = id + action_suffixes[act]
		action_names.append(act_name)

		InputMap.add_action(act_name, 0.25)
		InputMap.action_erase_events(act_name)
		for event in events[act]:
			InputMap.action_add_event(act_name, event)


func get_move_direction() -> Vector2:
	var direction := Vector2()

	direction.x -= Input.get_action_strength(action_names[Action.LEFT])
	direction.x += Input.get_action_strength(action_names[Action.RIGHT])
	direction.y -= Input.get_action_strength(action_names[Action.UP])
	direction.y += Input.get_action_strength(action_names[Action.DOWN])

	var length = direction.length()
	if length > 1:
		direction /= length

	return direction


func get_look_direction() -> Vector2:
	if gamepad_index < 0:
		return pc.position.direction_to(viewport.get_mouse_position())
	else:
		var direction := Vector2()

		direction.x -= Input.get_action_strength(action_names[Action.LOOK_LEFT])
		direction.x += Input.get_action_strength(action_names[Action.LOOK_RIGHT])
		direction.y -= Input.get_action_strength(action_names[Action.LOOK_UP])
		direction.y += Input.get_action_strength(action_names[Action.LOOK_DOWN])

		if direction != Vector2():
			look_direction = direction.normalized()

		return look_direction


func is_shoot_pressed() -> bool:
	return Input.is_action_pressed(action_names[Action.SHOOT])


func is_dodge_just_pressed() -> bool:
	return Input.is_action_just_pressed(action_names[Action.DODGE])


func is_reload_just_pressed() -> bool:
	return Input.is_action_just_pressed(action_names[Action.RELOAD])


func is_next_weapon_just_pressed() -> bool:
	return Input.is_action_just_pressed(action_names[Action.NEXT_WEAPON])


func is_prev_weapon_just_pressed() -> bool:
	return Input.is_action_just_pressed(action_names[Action.PREV_WEAPON])


func create_default_events():
	if gamepad_index < 0:
		return [
			[new_key_event(KEY_A), new_key_event(KEY_LEFT)],
			[new_key_event(KEY_D), new_key_event(KEY_RIGHT)],
			[new_key_event(KEY_W), new_key_event(KEY_UP)],
			[new_key_event(KEY_S), new_key_event(KEY_DOWN)],
			[],
			[],
			[],
			[],
			[new_mouse_button_event(BUTTON_LEFT)],
			[new_mouse_button_event(BUTTON_RIGHT)],
			[new_key_event(KEY_R), new_mouse_button_event(BUTTON_MASK_XBUTTON1)],
			[new_key_event(KEY_E)],
			[new_key_event(KEY_Q)],
		]
	else:
		return [
			[new_gamepad_axis_event(JOY_ANALOG_LX, -1), new_gamepad_button_event(JOY_DPAD_LEFT)],
			[new_gamepad_axis_event(JOY_ANALOG_LX, 1), new_gamepad_button_event(JOY_DPAD_RIGHT)],
			[new_gamepad_axis_event(JOY_ANALOG_LY, -1), new_gamepad_button_event(JOY_DPAD_UP)],
			[new_gamepad_axis_event(JOY_ANALOG_LY, 1), new_gamepad_button_event(JOY_DPAD_DOWN)],
			[new_gamepad_axis_event(JOY_ANALOG_RX, -1)],
			[new_gamepad_axis_event(JOY_ANALOG_RX, 1)],
			[new_gamepad_axis_event(JOY_ANALOG_RY, -1)],
			[new_gamepad_axis_event(JOY_ANALOG_RY, 1)],
			[new_gamepad_button_event(JOY_R2)],
			[new_gamepad_button_event(JOY_L2)],
			[new_gamepad_button_event(JOY_L)],
			[new_gamepad_button_event(JOY_R)],
			[],
		]


func new_key_event(key):
	var event := InputEventKey.new()
	event.scancode = key
	event.pressed = true
	return event


func new_mouse_button_event(button):
	var event := InputEventMouseButton.new()
	event.button_index = button
	event.pressed = true
	return event


func new_gamepad_axis_event(axis, value):
	var event := InputEventJoypadMotion.new()
	event.device = gamepad_id
	event.axis = axis
	event.axis_value = value
	return event


func new_gamepad_button_event(button):
	var event := InputEventJoypadButton.new()
	event.device = gamepad_id
	event.button_index = button
	event.pressed = true
	return event

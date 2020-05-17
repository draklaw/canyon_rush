extends Node

class_name Main


enum Mode {
	EASY,
	NORMAL,
	HARD,
	ENDLESS,
}


enum PlayerInput {
	DISABLED = -2,
	KEYBOARD = -1,
}


const setting_path := "user://settings.cfg"


export var mode: int = Mode.NORMAL
export var fullscreen := true


var players_input = [
	PlayerInput.KEYBOARD,
	PlayerInput.DISABLED,
	PlayerInput.DISABLED,
	PlayerInput.DISABLED,
]

var enter_pressed: bool = false

var keyboard_map: Dictionary = {
	PlayerController.Action.LEFT: ["a", "left"],
	PlayerController.Action.RIGHT: ["d", "right"],
	PlayerController.Action.UP: ["w", "up"],
	PlayerController.Action.DOWN: ["s", "down"],
#	PlayerController.Action.LOOK_LEFT: [],
#	PlayerController.Action.LOOK_RIGHT: [],
#	PlayerController.Action.LOOK_UP: [],
#	PlayerController.Action.LOOK_DOWN: [],
	PlayerController.Action.SHOOT: ["mouse_left"],
	PlayerController.Action.DODGE: ["mouse_right"],
	PlayerController.Action.RELOAD: ["r", "mouse_prev"],
	PlayerController.Action.NEXT_WEAPON: ["e", "wheel_down"],
	PlayerController.Action.PREV_WEAPON: ["q", "wheel_up"],
}


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

	load_config()

	OS.window_fullscreen = fullscreen

	save_config()

	var music_player = AudioStreamPlayer.new()
	music_player.stream = preload("res://assets/BGM.wav")
	music_player.volume_db = -24
	add_child(music_player)
	music_player.play()



func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

	if Input.is_key_pressed(KEY_ENTER):
		if not enter_pressed and Input.is_key_pressed(KEY_ALT):
			OS.window_fullscreen = !OS.window_fullscreen
		enter_pressed = true
	else:
		enter_pressed = false


func load_config() -> void:
	var config := ConfigFile.new()
	var config_error := config.load(setting_path)
	if config_error != OK:
		return

	fullscreen = config.get_value("display", "fullscreen", fullscreen)

	for key in keyboard_map:
		var name = PlayerController.action_name[key]
		var key_names = config.get_value("input", name)
		if key_names != null:
			keyboard_map[key] = key_names


func save_config() -> void:
	var config := ConfigFile.new()

	config.set_value("display", "fullscreen", fullscreen)

	for action in keyboard_map:
		var name = PlayerController.action_name[action]
		config.set_value("input", name, keyboard_map[action])

	if config.save(setting_path) != OK:
		pass

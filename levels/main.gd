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


export var mode: int = Mode.NORMAL

var players_input = [
	PlayerInput.KEYBOARD,
	PlayerInput.DISABLED,
	PlayerInput.DISABLED,
	PlayerInput.DISABLED,
]

var enter_pressed: bool = false


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

	if Input.is_key_pressed(KEY_ENTER):
		if not enter_pressed and Input.is_key_pressed(KEY_ALT):
			OS.window_fullscreen = !OS.window_fullscreen
		enter_pressed = true
	else:
		enter_pressed = false

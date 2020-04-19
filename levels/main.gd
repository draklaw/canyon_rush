extends Node


var enter_pressed: bool = false


func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

	if Input.is_key_pressed(KEY_ENTER):
		if not enter_pressed and Input.is_key_pressed(KEY_ALT):
			OS.window_fullscreen = !OS.window_fullscreen
		enter_pressed = true
	else:
		enter_pressed = false

extends Button


export(Main.Mode) var mode: int = Main.Mode.NORMAL
export var default: bool = false


onready var main = $"/root/main"


func _ready():
	grab_focus()


func _pressed() -> void:
	var mode_btn_group = $"../settings_group/difficulty_group/easy_button".group
	main.mode = mode_btn_group.get_pressed_button().mode

	var player_settings = $"../settings_group/player_group"
	for settings in player_settings.get_children():
		main.players_input[settings.player_index] = settings.get_input()

	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/world.tscn")

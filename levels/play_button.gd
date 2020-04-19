extends Button


export(Main.Mode) var mode: int = Main.Mode.NORMAL
export var default: bool = false


func _ready():
	if default:
		grab_focus()


func _pressed() -> void:
	$"/root/main".mode = mode
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/world.tscn")

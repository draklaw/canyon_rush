extends Button


export(Main.Mode) var mode: int = Main.Mode.NORMAL


func _pressed() -> void:
	$"/root/main".mode = mode
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/world.tscn")

extends Label


func _ready() -> void:
	if $"/root/main".mode == Main.Mode.ENDLESS:
		text = "Survived for:"

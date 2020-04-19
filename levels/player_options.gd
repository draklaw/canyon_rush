extends VBoxContainer


export var player_index: int = 0
export var enabled: bool = false


onready var label = $label
onready var input_combobox = $input_combobox


func _ready() -> void:
	label.text = "Player %d" % (player_index + 1)

	input_combobox.add_item("Disabled")
	input_combobox.set_item_metadata(0, -2)
	input_combobox.add_item("Keyboard")
	input_combobox.set_item_metadata(1, -1)

	for gamepad in Input.get_connected_joypads():
		var index = input_combobox.get_item_count()
		input_combobox.add_item(Input.get_joy_name(gamepad))
		input_combobox.set_item_metadata(index, gamepad)

	input_combobox.selected = 1 if enabled else 0


func get_input():
	var combobox = $input_combobox
	return combobox.get_item_metadata(combobox.selected)

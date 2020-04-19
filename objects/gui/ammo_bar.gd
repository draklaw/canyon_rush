tool
extends Control

class_name AmmoBar


export var texture: Texture setget set_texture
export var max_value: int = 10 setget set_max_value
export var value: int = 0 setget set_value
export var separation: int = 4 setget set_separation


func _ready() -> void:
	pass # Replace with function body.


func set_texture(texture_: Texture):
	texture = texture_
	update()


func set_max_value(max_value_: int):
	max_value = max_value_
	update()


func set_value(value_: int):
	value = value_
	update()


func set_separation(separation_: int):
	separation = separation_
	update()


func _get_minimum_size() -> Vector2:
	if texture:
		# warning-ignore:integer_division
		return Vector2(texture.get_width() / 2 * max_value + separation * (max_value - 1), texture.get_height())
	return Vector2()


func _draw():
	# warning-ignore:integer_division
	var item_width = texture.get_width() / 2
	var item_height = texture.get_height()

	var on_region = Rect2(0, 0, item_width, item_height)
	var off_region = Rect2(item_width, 0, item_width, item_height)

	for i in range(max_value):
		var x = i * (item_width + separation)
		var tex_rect = Rect2(x, 0, item_width, item_height)
		var region = on_region if i < value else off_region
		draw_texture_rect_region(
			texture, tex_rect, region
		)

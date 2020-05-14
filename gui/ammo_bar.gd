tool
extends Control

class_name AmmoBar


export var weapon_texture: Texture setget set_weapon_texture
export var weapon_index: int = 0 setget set_weapon_index

export var texture: Texture setget set_texture
export var max_value: int = 10 setget set_max_value
export var value: int = 0 setget set_value
export var separation: int = 4 setget set_separation


func _ready() -> void:
	pass # Replace with function body.


func set_weapon_texture(weapon_texture_: Texture):
	weapon_texture = weapon_texture_
	update()


func set_weapon_index(weapon_index_: int):
	weapon_index = weapon_index_
	update()


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
		return Vector2(
			70 + texture.get_width() / 2 * max_value + separation * (max_value - 1),
			64
		)
	return Vector2()


func _draw():
	if weapon_texture:
		draw_texture_rect_region(
			weapon_texture,
			Rect2(0, 0, 64, 64),
			Rect2(weapon_index * 32, 0, 32, 32)
		)

	if texture:
		# warning-ignore:integer_division
		var item_width = texture.get_width() / 2
		var item_height = texture.get_height()

		var on_region = Rect2(0, 0, item_width, item_height)
		var off_region = Rect2(item_width, 0, item_width, item_height)


		for i in range(max_value):
			var x = 70 + i * (item_width + separation)
			var tex_rect = Rect2(x, 32, item_width, item_height)
			var region = on_region if i < value else off_region
			draw_texture_rect_region(
				texture, tex_rect, region
			)

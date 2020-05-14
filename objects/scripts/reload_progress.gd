tool
extends Node2D


export var value: float = 0 setget set_value
export var min_value: float = 0 setget set_min_value
export var max_value: float = 100 setget set_max_value

export var texture: Texture setget set_texture
export var color: Color = Color(1, 1, 1, 1) setget set_color


func set_value(value_: float) -> void:
	value = value_
	update()


func set_min_value(min_value_: float) -> void:
	min_value = min_value_
	update()


func set_max_value(max_value_: float) -> void:
	max_value = max_value_
	update()


func set_texture(texture_: Texture) -> void:
	texture = texture_
	update()


func set_color(color_: Color) -> void:
	color = color_
	update()


func _draw() -> void:
	if texture == null:
		return

	var nvalue := clamp((value - min_value) / (max_value - min_value), 0, 1)
	if nvalue == 0:
		return

	var h_width := texture.get_width() / 2.0
	var h_height := texture.get_height() / 2.0

	if nvalue == 1:
		draw_texture_rect_region(
			texture,
			Rect2(-h_width, -h_height, 2 * h_width, 2 * h_height),
			Rect2(0, 0, 2 * h_width, 2 * h_height)
		)

	var pts = PoolVector2Array()
	var colors = PoolColorArray()
	var uvs = PoolVector2Array()

	pts.append(Vector2(0, 0))
	colors.append(Color(color))
	uvs.append(Vector2(0.5, 0.5))

	pts.append(Vector2(0, -h_height))
	colors.append(Color(color))
	uvs.append(Vector2(0.5, 0))

	if nvalue > 0.125:
		pts.append(Vector2(h_width, -h_height))
		colors.append(Color(color))
		uvs.append(Vector2(1, 0))

	if nvalue > 0.375:
		pts.append(Vector2(h_width, h_height))
		colors.append(Color(color))
		uvs.append(Vector2(1, 1))

	if nvalue > 0.625:
		pts.append(Vector2(-h_width, h_height))
		colors.append(Color(color))
		uvs.append(Vector2(0, 1))

	if nvalue > 0.875:
		pts.append(Vector2(-h_width, -h_height))
		colors.append(Color(color))
		uvs.append(Vector2(0, 0))

	var x := sin(nvalue * 2 * PI)
	var y := -cos(nvalue * 2 * PI)
	if abs(x) > abs(y):
		y /= abs(x)
		x /= abs(x)
	else:
		x /= abs(y)
		y /= abs(y)

	pts.append(Vector2(x * h_width, y * h_height))
	colors.append(Color(color))
	uvs.append(Vector2((x + 1) / 2, (y + 1) / 2))

	draw_polygon(pts, colors, uvs, texture)

extends MarginContainer


onready var health_bar: ProgressBar = $main_layout/top_bar/health_bar
onready var human_bar: ProgressBar = $main_layout/top_bar/human_bar

const human_sprite = [
	preload("res://objects/gui/human_bar_0.tres"),
	preload("res://objects/gui/human_bar_1.tres"),
	preload("res://objects/gui/human_bar_2.tres"),
	preload("res://objects/gui/human_bar_3.tres"),
	preload("res://objects/gui/human_bar_4.tres"),
]


func _ready() -> void:
	pass


func set_pc_health(hp):
	health_bar.value = hp


func set_human_health(hp):
	var points = ceil(hp / 25)
	human_bar.texture = human_sprite[points]

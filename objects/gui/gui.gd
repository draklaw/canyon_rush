extends MarginContainer


onready var health_bar: ProgressBar = $main_layout/health_bar
onready var human_bar: ProgressBar = $main_layout/human_row/human_bar
onready var timer: ProgressBar = $main_layout/human_row/evac_bar/timer

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


func set_timer(time: float):
	var int_time = max(int(ceil(time)), 0)
	var minutes = int_time / 60
	var seconds = int_time % 60

	timer.text = "%02d:%02d" % [minutes, seconds]

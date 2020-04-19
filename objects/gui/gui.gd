extends Control


onready var health_bar: ProgressBar = $main_layout/health_bar
onready var human_bar: ProgressBar = $main_layout/human_row/human_bar
onready var timer: Label = $main_layout/human_row/evac_bar/timer
onready var ammo_bar: AmmoBar = $main_layout/ammo_bar


var weapon: Weapon


const human_sprite = [
	preload("res://objects/gui/human_bar_0.tres"),
	preload("res://objects/gui/human_bar_1.tres"),
	preload("res://objects/gui/human_bar_2.tres"),
	preload("res://objects/gui/human_bar_3.tres"),
	preload("res://objects/gui/human_bar_4.tres"),
]


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


func set_weapon(weapon_: Weapon):
	if weapon:
		weapon.disconnect("ammo_count_changed", ammo_bar, "set_value")

	weapon = weapon_

	if weapon:
		ammo_bar.max_value = weapon.ammo_capacity
		ammo_bar.value = weapon.ammo_count
		weapon.connect("ammo_count_changed", ammo_bar, "set_value")


func hide_start_panel():
	$start_panel.visible = false


func show_game_over_panel():
	$game_over_panel.visible = true

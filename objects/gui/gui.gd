extends Control


#onready var health_bar: ProgressBar = $main_layout/players_row/player_info_1/health_bar
#onready var ammo_bar: AmmoBar = $main_layout/players_row/player_info_1/ammo_bar

onready var player_info = [
	$main_layout/players_row/player_info_1,
	$main_layout/players_row/player_info_2,
	$main_layout/players_row/player_info_3,
	$main_layout/players_row/player_info_4,
]

onready var human_bar: ProgressBar = $main_layout/human_row/human_bar
onready var timer: Label = $main_layout/human_row/evac_bar/timer


const human_sprite = [
	preload("res://objects/gui/human_bar_0.tres"),
	preload("res://objects/gui/human_bar_1.tres"),
	preload("res://objects/gui/human_bar_2.tres"),
	preload("res://objects/gui/human_bar_3.tres"),
	preload("res://objects/gui/human_bar_4.tres"),
]


func set_player_info_visible(index: int, visible: bool):
	player_info[index].visible = visible


func set_pc_health(player: Node, hp: float):
	player_info[player.player_index].get_node("health_bar").value = hp


func set_human_health(_human: Node, hp):
	var points = ceil(hp / 25)
	human_bar.texture = human_sprite[points]


func set_timer(time: float):
	var int_time = max(int(ceil(time)), 0)
	var minutes = int_time / 60
	var seconds = int_time % 60

	timer.text = "%02d:%02d" % [minutes, seconds]


func set_weapon(player_index: int, weapon_: Weapon):
	var info = player_info[player_index]
	var ammo_bar = info.get_node("ammo_bar")

	if info.weapon:
		info.weapon.disconnect("ammo_count_changed", ammo_bar, "set_value")

	info.weapon = weapon_

	if info.weapon:
		ammo_bar.weapon_index = info.weapon.weapon_index
		ammo_bar.max_value = info.weapon.ammo_capacity
		ammo_bar.value = info.weapon.ammo_count
		info.weapon.connect("ammo_count_changed", ammo_bar, "set_value")


func hide_start_panel():
	$start_panel.visible = false


func show_game_over_panel():
	$game_over_panel.visible = true

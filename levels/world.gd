extends Node


export var time_before_win_easy: float = 30
export var time_before_win_normal: float = 600
export var time_before_win_hard: float = 900


signal remaining_time_changed


enum {
	STARTING,
	PLAYING,
	GAME_OVER,
}


var state: int = STARTING
var remaining_time: float

onready var main = $"/root/main"
onready var gui = $gui
onready var human = $human
onready var pc = $pc


func _ready() -> void:
	get_tree().paused = true

	human.connect("dying", self, "set_game_over")

	if main.mode == Main.Mode.EASY:
		remaining_time = time_before_win_easy
	elif main.mode == Main.Mode.NORMAL:
		remaining_time = time_before_win_normal
	elif main.mode == Main.Mode.HARD:
		remaining_time = time_before_win_hard
	else:
		remaining_time = 0
	emit_signal("remaining_time_changed", remaining_time)

	pc.set_weapon_index(PlayerCharacter.WeaponType.MACHINE_GUN)

	for node in get_children():
		node.pause_mode = Node.PAUSE_MODE_STOP


func _process(delta: float) -> void:
	if state == PLAYING:
		if main.mode != Main.Mode.ENDLESS:
			remaining_time -= delta
			if remaining_time <= 0:
				get_tree().change_scene("res://levels/end_screen.tscn")
		else:
			remaining_time += delta
		emit_signal("remaining_time_changed", remaining_time)

	elif state == STARTING:
		if Input.is_action_just_pressed("ui_accept"):
			state = PLAYING
			get_tree().paused = false
			gui.hide_start_panel()
	elif state == GAME_OVER:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://levels/world.tscn")


func set_game_over():
	state = GAME_OVER
	get_tree().paused = true
	gui.show_game_over_panel()

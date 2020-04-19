extends Node2D


export var time_before_win: float = 600


signal remaining_time_changed


enum {
	STARTING,
	PLAYING,
	GAME_OVER,
}


var state: int = STARTING
var remaining_time: float

onready var gui = $gui
onready var human = $human
onready var pc = $pc


func _ready() -> void:
	get_tree().paused = true

	human.connect("dying", self, "set_game_over")

	remaining_time = time_before_win

	#pc.set_weapon(pc.gun)
	pc.set_weapon(pc.machine_gun)
	#pc.set_weapon(pc.shotgun)

	for node in get_children():
		node.pause_mode = Node.PAUSE_MODE_STOP


func _process(delta: float) -> void:
	if state == PLAYING:
		remaining_time -= delta
		emit_signal("remaining_time_changed", remaining_time)

		if remaining_time <= 0:
			print("TODO: Win state")
	elif state == STARTING:
		if Input.is_action_just_pressed("p1_shoot"):
			state = PLAYING
			get_tree().paused = false
			gui.hide_start_panel()
	elif state == GAME_OVER:
		if Input.is_action_just_pressed("p1_shoot"):
			get_tree().change_scene("res://levels/world.tscn")


func set_game_over():
	state = GAME_OVER
	get_tree().paused = true
	gui.show_game_over_panel()

extends Node2D


export var time_before_win: float = 600


signal remaining_time_changed


var remaining_time: float

onready var pc = $pc


func _ready() -> void:
	remaining_time = time_before_win

	#pc.set_weapon(pc.gun)
	pc.set_weapon(pc.machine_gun)
	#pc.set_weapon(pc.shotgun)


func _process(delta: float) -> void:
	remaining_time -= delta
	emit_signal("remaining_time_changed", remaining_time)

	if remaining_time <= 0:
		print("TODO: Win state")

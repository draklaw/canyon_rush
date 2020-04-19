extends Node2D


export var time_before_win: float = 600


signal remaining_time_changed


var remaining_time: float


func _ready() -> void:
	remaining_time = time_before_win


func _process(delta: float) -> void:
	remaining_time -= delta
	emit_signal("remaining_time_changed", remaining_time)

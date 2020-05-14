extends Resource

class_name SpawnInfo


export var alien: PackedScene = null
export var min_flock_size: int = 1
export var max_flock_size: int = 1
export var delay_start: float = 60
export var delay_end: float = 60


func _init(alien_: PackedScene=null, min_flock_size_: int=1, max_flock_size_: int=1,
		delay_start_: float=1, delay_end_: float=1):
	alien = alien_
	min_flock_size = min_flock_size_
	max_flock_size = max_flock_size_
	delay_start = delay_start_
	delay_end = delay_end_


func rand_flock_size():
	if min_flock_size == max_flock_size:
		return min_flock_size

	return min_flock_size + randi() % (max_flock_size - min_flock_size)

extends KinematicBody2D

class_name Character


export var max_hp: float = 100
export var hp: float = 100

export var recovery_time: float = 0

export var damage_on_hit: float = 0


var remaining_recovery_time = 0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	remaining_recovery_time -= delta

	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		var damage_on_hit = collider.get("damage_on_hit")
		if damage_on_hit:
			take_damage(damage_on_hit)


func take_damage(damage: float):
	if damage <= 0 or remaining_recovery_time > 0:
		return

	hp -= damage
	remaining_recovery_time = recovery_time

	if hp <= 0:
		die()


func die():
	queue_free()

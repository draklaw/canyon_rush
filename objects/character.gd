extends KinematicBody2D

class_name Character


export var max_hp: float = 100
export var hp: float = 100

export var recovery_time: float = 0

export var damage_on_hit: float = 0


signal took_damage
signal dying


var remaining_recovery_time = 0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	remaining_recovery_time -= delta


func take_damage(damage: float):
	if damage <= 0 or remaining_recovery_time > 0:
		return

	hp -= damage
	remaining_recovery_time = recovery_time

	emit_signal("took_damage", hp)

	if hp <= 0:
		die()


func die():
	emit_signal("dying")
	queue_free()

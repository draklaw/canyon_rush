extends Area2D

class_name Repkit

func _ready():
	assert(connect("body_entered", self, "pick_me_up") == OK)

func pick_me_up(dood):
	if dood.hp < dood.max_hp:
		dood.hp = dood.max_hp
		queue_free()


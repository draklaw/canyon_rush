extends Area2D

class_name Repkit

func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "pick_me_up")

func pick_me_up(dood):
	if dood.hp < dood.max_hp:
		dood.hp = dood.max_hp
		queue_free()


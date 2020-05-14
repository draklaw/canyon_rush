extends Character


onready var sprite: AnimatedSprite = $sprite


func _ready() -> void:
	var err = connect("took_damage", self, "on_took_damage")
	assert(err == OK)

	err = connect("dying", self, "on_dying")
	assert(err == OK)


func on_took_damage(_human: Node, _damage: float):
	var points = ceil(hp / max_hp * 4)
	sprite.frame = 4 - points
	$sprite/hit_stream.play()


func on_dying():
	var node = $sprite.duplicate(0)
	node.get_node("ded_stream").play()
	node.frame = 4
	node.transform = $sprite.get_global_transform()
	$"..".add_child_below_node(self, node)

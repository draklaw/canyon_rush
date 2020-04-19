extends Character


onready var sprite: AnimatedSprite = $sprite


func _ready() -> void:
	var err = connect("took_damage", self, "on_took_damage")
	assert(err == OK)


func on_took_damage(_damage: float):
	var points = ceil(hp / 25)
	sprite.frame = 4 - points

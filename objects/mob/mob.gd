extends Character


export var speed: float = 192


var wiggle = 0.5


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var offset = Vector2()

	offset.x -= 1

	wiggle += (randf()-0.5)/20
	wiggle = clamp(0, wiggle, 1)
	if wiggle < 0.15:
		offset.y -= 1
	if wiggle > 0.85:
		offset.y += 1

	offset = offset.normalized() * speed

	move_and_slide(offset)

	._physics_process(delta)

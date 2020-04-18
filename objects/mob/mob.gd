extends KinematicBody2D

export var speed: float = 64
var rng
var wiggle = 0.5

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	randomize()

func _physics_process(delta: float) -> void:
	var offset = Vector2()

	offset.x -= 1
	
	wiggle += (rng.randf()-0.5)/20
	wiggle = clamp(0, wiggle, 1)
	if wiggle < 0.15:
		offset.y -= 1
	if wiggle > 0.85:
		offset.y += 1

	offset = offset.normalized() * speed

	move_and_slide(offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

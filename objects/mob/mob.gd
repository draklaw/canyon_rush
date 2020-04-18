extends Character

export var speed: float = 192

# Behavior :
# 1. Clear shots (dash).
# 2. Go west.
# 3. Clear walls
# 4. Clear PC.
# 5. Flock hive.
# 6. Wiggle ?

enum {
 RUSHER, # Eyes on the prize
 FASTER, # Gotta go fast
 MASHER, # Go for the eyes
 RUNNER, # Better part of valor
 DASHER, # Can't touch this
 TYPES
}

const DASH_REGEN = 0.3;
const DASH_RANGE = 80;
const DASH_COST = 80;

var type;
var stat;

func _ready() -> void:
	self.add_to_group("hive")
	self.type = randi() % TYPES;
	self.stat = 80 + randi() % 40;

func f(l):
	return 

func _physics_process(delta: float) -> void:
	var offset = Vector2(0,0)
	
	var pc = $"/root/world/pc"
	var sep = Vector2(0,0)
	if (pc):
		sep = (pc.position - position)
	
	if type == MASHER and sep.length() < 500 * stat/100:
		offset += 3 * sep
	if type == RUNNER and sep.length() < 300 * stat/100:
		offset -= sep
	
	offset.x -= 1000 if type == RUSHER else 200
	
	offset = offset.normalized() * speed * (1.5 if type == FASTER else 1)
	
	if type == DASHER:
		if stat < 100:
			stat += DASH_REGEN
		if stat > DASH_COST:
			for s in get_tree().get_nodes_in_group("shoots"):
				sep = position - s.position;
				if sep.length() < DASH_RANGE:
					offset = 60*DASH_RANGE * sep.rotated(PI/2 if randi()%2 else -PI/2).normalized()
					stat -= DASH_COST
	
	move_and_slide(offset)
	
	._physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage: float) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()

extends Character

export var speed: float = 192

enum {
	RUSHER, # Eyes on the prize
	FASTER, # Gotta go fast
	MASHER, # Go for the eyes
	FLEEER, # Better part of valor
	TANKER, # Shrug it off
	DASHER, # Can't touch this
	SNIPER, # Boom headshot
	TYPES
}

const RUSH_FACTOR = 5
const FAST_FACTOR = 1.5
const MASH_RANGE = 600
const FLEE_RANGE = 300
const DASH_REGEN = 0.3
const DASH_RANGE = 80
const DASH_COST = 80
const SNIP_CHARGE = 1
const SNIP_DAMAGE = 25

var type
var stat

var shot = preload("res://objects/gun_shot/gun_shot.tscn")
var acid_pic = preload("res://objects/gun_shot/acid_shot.png")

func _ready() -> void:
	add_to_group("hive")
	type = randi() % TYPES;
	stat = 80 + randi() % 40;
	if type == TANKER:
		hp += stat

func _physics_process(delta: float) -> void:
	var offset = Vector2(0,0)

	var sep = Vector2(0,0)
	if has_node("/root/world/pc"):
		var pc = $"/root/world/pc"
		sep = (pc.position - position)

	if type == MASHER and sep.length() < MASH_RANGE * stat/100:
		offset += 3 * sep
	if type == FLEEER and sep.length() < FLEE_RANGE * stat/100:
		offset -= sep

	offset.x -= speed * (RUSH_FACTOR if type == RUSHER else 1)

	offset = offset.normalized() * speed * (FAST_FACTOR if type == FASTER else 1)

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

	if type == SNIPER:
		stat -= SNIP_CHARGE
		if stat < 0:
			stat = 100
			var acid = shot.instance()
			acid.get_node("gun_shot").texture = acid_pic
			acid.collision_mask = 0x3
			acid.damage = SNIP_DAMAGE
			acid.position = position
			acid.rotation = sep.angle()
			get_node("/root/world/shots").add_child(acid)

	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		if collider is Character:
			collider.take_damage(damage_on_hit)

	._physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage: float) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()

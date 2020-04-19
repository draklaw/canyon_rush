extends Character

class_name Mob

export var speed: float = 192

enum {
	BUGGER, # Nothing special
	RUSHER, # Eyes on the prize
	FASTER, # Gotta go fast
	MASHER, # Go for the eyes
	FLEEER, # Better part of valor
	TANKER, # Shrug it off
	DASHER, # Can't touch this
	SNIPER, # Boom headshot
	MOB_TYPES
}

const trash: Array = [20, 4,  0,  2, 10,  1,  0,  0]
const leet:  Array = [ 0, 5, 20, 20,  0, 20, 10, 30]

const sprites = [
	preload("res://objects/mob/masher_anims.tres"),
	preload("res://objects/mob/masher_anims.tres"),
	preload("res://objects/mob/masher_anims.tres"),
	preload("res://objects/mob/masher_anims.tres"),
	preload("res://objects/mob/fleer_anims.tres"),
	preload("res://objects/mob/tanker_anims.tres"),
	preload("res://objects/mob/masher_anims.tres"),
	preload("res://objects/mob/sniper_anims.tres"),
]

const RUSH_FACTOR: float = 5.0
const FAST_FACTOR: float = 1.5
const MASH_RANGE: float = 600.0
const FLEE_RANGE: float = 300.0
const DASH_REGEN: float = 1.0
const DASH_RANGE: float = 80.0
const DASH_COST: float = 80.0
const SNIP_CHARGE: float = 1.0
const SNIP_DAMAGE: float = 25.0

var type: int = 0
var stat: float = 100
var attack: float = 100

var shot = preload("res://objects/gun_shot/gun_shot.tscn")
var acid_pic = preload("res://objects/gun_shot/acid_shot.png")


func set_mobtype (ntype: int) -> void:
	type = ntype
	stat = 80 + randi() % 40;
	if type == TANKER:
		hp += stat

func _ready() -> void:
	add_to_group("hive")
	i_am_a_mob_instance = true
	$sprite.frames = sprites[type]

func _physics_process(delta: float) -> void:
	var move = Vector2(0,0)
	var tobot = Vector2(0,0)
	var tohuman = Vector2(0,0)

	if has_node("/root/world/pc"):
		tobot = $"/root/world/pc".position - position

	if type == MASHER and tobot.length() < MASH_RANGE * stat/100:
		move += 3 * tobot
	elif type != SNIPER and tobot.length() < 200:
		move += 3 * tobot
	if type == FLEEER and tobot.length() < FLEE_RANGE * stat/100:
		move -= tobot

	if has_node("/root/world/human"):
		tohuman = $"/root/world/human".position - position

	if type == RUSHER or tohuman.length() < 300:
		move += tohuman
	else:
		move.x -= speed

	move = move.normalized() * speed * (FAST_FACTOR if type == FASTER else 1)

	if type == DASHER:
		if stat < 100:
			stat += DASH_REGEN
		if stat > DASH_COST:
			for s in get_tree().get_nodes_in_group("shoots"):
				var toshot = position - s.position;
				if toshot.length() < DASH_RANGE:
					move = 60*DASH_RANGE * toshot.rotated(PI/2 if randi()%2 else -PI/2).normalized()
					stat -= DASH_COST

	move_and_slide(move)

	attack -= 1
	if type == SNIPER:
		stat -= SNIP_CHARGE
		if stat < 0:
			stat = 100
			var acid = shot.instance()
			acid.get_node("gun_shot").texture = acid_pic
			acid.collision_mask = 0x3
			acid.damage = SNIP_DAMAGE
			acid.position = position
			acid.rotation = tobot.angle()
			get_node("/root/world/shots").add_child(acid)
	else:
		for i in range(get_slide_count()):
			var collider = get_slide_collision(i).collider
			if attack < 0 and collider is Character and not collider.i_am_a_mob_instance:
				collider.take_damage(damage_on_hit)
				attack = 100

	._physics_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func take_damage(damage: float) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()

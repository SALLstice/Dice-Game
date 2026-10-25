class_name Creature
extends RefCounted
## The player or a monster: some HP and a pool of dice.

var display_name: String
var sprite: String
var max_hp: int
var hp: int
var dice: Array[Die] = []
var blank_count := 0
var totals := {}


func _init(p_name: String, p_sprite: String, p_hp: int, p_dice: Array) -> void:
	display_name = p_name
	sprite = p_sprite
	max_hp = p_hp
	hp = p_hp
	dice.assign(p_dice)


func is_dead() -> bool:
	return hp <= 0


func roll_all() -> void:
	for die in dice:
		die.roll()
	calc_totals()


func calc_totals() -> void:
	blank_count = 0
	for die in dice:
		if die.current().type == Face.Type.BLANK:
			blank_count += 1

	for type in [Face.Type.ATTACK, Face.Type.DEFEND, Face.Type.HEAL, Face.Type.MAGIC]:
		var total := 0
		for tier in Face.TIERS:
			for die in dice:
				var face := die.current()
				if face.type == type and face.priority() == tier:
					total = face.apply(total, self)
		totals[type] = total


## Returns the damage actually taken after defence.
func take_damage(amount: int) -> int:
	var taken := maxi(0, amount - totals[Face.Type.DEFEND])
	hp -= taken
	return taken


func heal() -> void:
	hp = mini(max_hp, hp + totals[Face.Type.HEAL])

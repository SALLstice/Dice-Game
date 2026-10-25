class_name Creature
extends RefCounted
## The player or a monster: some HP and a pool of dice.

## Scrap needed for a new blank die. Only the player collects scrap.
const SCRAP_PER_DIE := 300

var display_name: String
var sprite: String
var max_hp: int
var hp: int
var dice: Array[Die] = []
var blank_count := 0
var totals := {}
var scrap := 0


func _init(p_name: String, p_sprite: String, p_hp: int, p_dice: Array) -> void:
	display_name = p_name
	sprite = p_sprite
	max_hp = p_hp
	hp = p_hp
	dice.assign(p_dice)


func is_dead() -> bool:
	return hp <= 0


## Starts a new turn: clears per-turn face state, rolls everything, winds springs.
func roll_all() -> void:
	for die in dice:
		for face in die.faces:
			face.reset_turn()
		die.roll()

	var winders := 0
	for die in dice:
		if die.current().id == "spring_winder":
			winders += 1
	for die in dice:
		for face in die.faces:
			if face.id == "spring":
				face.winds_inc = 1 + winders
		_on_rolled(die)
	calc_totals()


func reroll(die: Die) -> void:
	die.roll()
	_on_rolled(die)
	calc_totals()


func cash_spring(face: Face) -> void:
	face.used = true
	face.cashed = face.winds
	face.winds = 0
	calc_totals()


func _on_rolled(die: Die) -> void:
	var face := die.current()
	if face.id == "spring":
		face.winds += face.winds_inc


func calc_totals() -> void:
	blank_count = 0
	for die in dice:
		if die.current().id == "blank":
			blank_count += 1

	for type in [Face.Type.ATTACK, Face.Type.DEFEND, Face.Type.HEAL, Face.Type.MAGIC]:
		totals[type] = 0
	# Tier by tier across every colour, so converters see the finished totals.
	for tier in Face.TIERS:
		for die in dice:
			var face := die.current()
			if face.type != Face.Type.BLANK and face.priority() == tier:
				totals[face.type] = face.apply(totals[face.type], self)


## Returns the damage actually taken after defence.
func take_damage(amount: int) -> int:
	var taken := maxi(0, amount - totals[Face.Type.DEFEND])
	hp -= taken
	return taken


func heal() -> void:
	hp = mini(max_hp, hp + totals[Face.Type.HEAL])


## Returns how many new blank dice the scrap bought.
func add_scrap(amount: int) -> int:
	scrap += amount
	var bought := 0
	while scrap >= SCRAP_PER_DIE:
		scrap -= SCRAP_PER_DIE
		dice.append(Die.new(Die.BLANK_IDS, Die.BLANK_TYPES))
		bought += 1
	return bought

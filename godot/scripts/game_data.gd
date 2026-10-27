class_name GameData
extends RefCounted
## Starting dice, monsters and run structure. Monster stats come from the Unity GameManagerScript.

const PLAYER_HP := 20

## A run is RUN_FLOORS fights. Every BOSS_EVERY-th floor is a boss, and each block of
## BOSS_EVERY floors is an "act" that makes monsters tougher.
const RUN_FLOORS := 20
const BOSS_EVERY := 5
## Per act after the first: extra HP (0.5 = +50%) and how far number faces step up (one -> two).
const HP_SCALE_PER_ACT := 0.5
const FACE_STEPS_PER_ACT := 1

## Each die is [face ids, face types]. Types: -1 blank, 0 attack, 1 defend, 2 heal, 3 magic.
## Normal monsters appear from `min_floor` on; bosses only on boss floors.
const MONSTERS := [
	{"name": "Rat", "sprite": "rat", "hp": 3, "boss": false, "min_floor": 1, "dice": [
		[["blank", "blank", "one", "one", "one", "one"], [-1, -1, 0, 0, 0, 0]],
		[["blank", "blank", "one", "one", "one", "one"], [-1, -1, 0, 0, 0, 0]],
	]},
	{"name": "Goblin", "sprite": "goblin", "hp": 6, "boss": false, "min_floor": 3, "dice": [
		[["blank", "one", "one", "one", "two", "two"], [-1, 0, 0, 0, 0, 0]],
		[["blank", "one", "one", "one", "two", "two"], [-1, 0, 0, 0, 0, 0]],
	]},
	{"name": "Treant", "sprite": "treant", "hp": 30, "boss": true, "min_floor": 1, "dice": [
		[["one", "two", "two", "two", "three", "four"], [0, 0, 0, 0, 0, 0]],
		[["one", "two", "two", "two", "three", "four"], [1, 1, 1, 1, 1, 1]],
	]},
]


static func new_player() -> Creature:
	var faces := ["blank", "blank", "one", "one", "one", "two"]
	return Creature.new("You", "", PLAYER_HP, [
		Die.new(faces, [-1, -1, 0, 0, 0, 0]),
		Die.new(faces, [-1, -1, 1, 1, 1, 1]),
	])


static func is_boss_floor(floor_num: int) -> bool:
	return floor_num % BOSS_EVERY == 0


static func monster_for_floor(floor_num: int) -> Creature:
	var boss := is_boss_floor(floor_num)
	var def: Dictionary = MONSTERS.filter(
		func(m): return m.boss == boss and floor_num >= m.min_floor).pick_random()
	@warning_ignore("integer_division")
	var act := (floor_num - 1) / BOSS_EVERY
	var dice := []
	for d in def.dice:
		var ids := []
		for id in d[0]:
			ids.append(_step_number(id, act * FACE_STEPS_PER_ACT))
		dice.append(Die.new(ids, d[1]))
	var hp := ceili(def.hp * (1.0 + HP_SCALE_PER_ACT * act))
	return Creature.new(def.name, def.sprite, hp, dice)


## Raises a number face by `steps` (one -> two), capped at twelve. Other faces are unchanged.
static func _step_number(id: String, steps: int) -> String:
	if not Face.NUMBERS.has(id):
		return id
	var names := Face.NUMBERS.keys()
	return names[mini(names.find(id) + steps, names.size() - 1)]

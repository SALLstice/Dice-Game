class_name GameData
extends RefCounted
## Starting dice, monsters and run structure. Monster stats come from the Unity GameManagerScript.

const PLAYER_HP := 20

## A run is RUN_FLOORS fights. Every BOSS_EVERY-th floor is a boss, and each block of
## BOSS_EVERY floors is an "act" that makes monsters tougher.
const RUN_FLOORS := 20
const BOSS_EVERY := 5

## Per act: [HP multiplier, how far number faces step up (one -> two)].
## Tuned by simulation so each act is harder: about 97/95/91/90% per normal fight
## and 80/68/46/30% per boss, for a player who just puts loot over their weakest faces.
const NORMAL_SCALING := [[2.0, 0], [2.5, 1], [4.0, 2], [5.5, 3]]
const BOSS_SCALING := [[1.0, 0], [3.0, 1], [3.5, 3], [5.5, 5]]

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
	{"name": "Treant", "sprite": "treant", "hp": 15, "boss": true, "min_floor": 1, "dice": [
		[["blank", "one", "one", "one", "two", "two"], [-1, 0, 0, 0, 0, 0]],
		[["one", "one", "two", "two", "two", "two"], [1, 1, 1, 1, 1, 1]],
	]},
]


static func new_player() -> Creature:
	var faces := ["blank", "blank", "one", "one", "one", "two"]
	return Creature.new("You", "", PLAYER_HP, [
		Die.new(faces, [-1, -1, 0, 0, 0, 0]),
		Die.new(faces, [-1, -1, 1, 1, 1, 1]),
	])


## The die offered after beating boss number `boss_number`: [0,0,0,N,N,N+1] in one colour.
static func boss_die(boss_number: int, type: int) -> Die:
	var n := Face.number_id(boss_number)
	return Die.new(
		["blank", "blank", "blank", n, n, Face.number_id(boss_number + 1)],
		[-1, -1, -1, type, type, type])


static func is_boss_floor(floor_num: int) -> bool:
	return floor_num % BOSS_EVERY == 0


static func monster_for_floor(floor_num: int) -> Creature:
	var boss := is_boss_floor(floor_num)
	var def: Dictionary = MONSTERS.filter(
		func(m): return m.boss == boss and floor_num >= m.min_floor).pick_random()
	@warning_ignore("integer_division")
	var act := (floor_num - 1) / BOSS_EVERY
	var scaling: Array = (BOSS_SCALING if boss else NORMAL_SCALING)[act]
	var dice := []
	for d in def.dice:
		var ids := []
		for id in d[0]:
			ids.append(_step_number(id, scaling[1]))
		dice.append(Die.new(ids, d[1]))
	var hp := ceili(def.hp * scaling[0])
	return Creature.new(def.name, def.sprite, hp, dice)


## Raises a number face by `steps` (one -> two), capped at twelve. Other faces are unchanged.
static func _step_number(id: String, steps: int) -> String:
	if not Face.NUMBERS.has(id):
		return id
	return Face.number_id(Face.NUMBERS[id] + steps)

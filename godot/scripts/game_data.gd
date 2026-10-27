class_name GameData
extends RefCounted
## Starting dice and monster definitions, copied from the Unity GameManagerScript.

const PLAYER_HP := 20

## A monster can appear once you have this many kills. Each die is [face ids, face types]. Types: -1 blank, 0 attack, 1 defend, 2 heal, 3 magic.
const MONSTERS := [
	{"name": "Rat", "sprite": "rat", "hp": 3, "unlock_kills": 0, "dice": [
		[["blank", "blank", "one", "one", "one", "one"], [-1, -1, 0, 0, 0, 0]],
		[["blank", "blank", "one", "one", "one", "one"], [-1, -1, 0, 0, 0, 0]],
	]},
	{"name": "Goblin", "sprite": "goblin", "hp": 6, "unlock_kills": 2, "dice": [
		[["blank", "one", "one", "one", "two", "two"], [-1, 0, 0, 0, 0, 0]],
		[["blank", "one", "one", "one", "two", "two"], [-1, 0, 0, 0, 0, 0]],
	]},
	{"name": "Treant", "sprite": "treant", "hp": 30, "unlock_kills": 5, "dice": [
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


static func random_monster(kills: int) -> Creature:
	var def: Dictionary = MONSTERS.filter(func(m): return kills >= m.unlock_kills).pick_random()
	var dice := []
	for d in def.dice:
		dice.append(Die.new(d[0], d[1]))
	return Creature.new(def.name, def.sprite, def.hp, dice)

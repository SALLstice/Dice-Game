class_name Face
extends RefCounted
## One side of a die. `type` picks which total it feeds, `id` picks what it does.
## Faces live on their die between turns, so springs keep their winds.

enum Type { BLANK = -1, ATTACK, DEFEND, HEAL, MAGIC }

## Totals are built tier by tier, same as the Unity version:
## 0 = blank bonus, 1 = numbers and springs, 2 = even/odd multipliers, 3 = converters.
const TIERS := [0, 1, 2, 3]

const NUMBERS := {
	"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6,
	"seven": 7, "eight": 8, "nine": 9, "ten": 10, "eleven": 11, "twelve": 12,
}

## Loot weights from the Unity "Dice Sides" objects. Higher = more common.
const LOOT_WEIGHTS := {
	"one": 100, "two": 90, "three": 85, "four": 80, "five": 75, "six": 70,
	"blank": 80, "blank_bonus": 30, "even": 50, "odd": 50, "reroll": 30,
	"bomb": 20, "spring": 10, "half_shields_to_swords": 10, "spring_winder": 5,
}

## Faces that stay white and never feed a total directly.
const UTILITY := ["blank", "bomb", "reroll", "spring_winder"]

## Faces you click, then click a target die.
const TARGETED := ["bomb", "reroll"]

## Face ids whose sprite file name differs from the id.
const SPRITES := {
	"blank_bonus": "blank3", "even": "even2", "odd": "odd3",
	"spring_winder": "springs", "half_shields_to_swords": "halfshieldtosword",
}

const DESCRIPTIONS := {
	"blank": "Blank. Does nothing on its own.",
	"blank_bonus": "+3 for every blank you rolled.",
	"even": "Doubles this colour's total if it is even.",
	"odd": "Triples this colour's total if it is odd.",
	"spring": "Winds up each time it is rolled. Click to cash in the winds.",
	"spring_winder": "While showing, your springs wind one extra this turn.",
	"reroll": "Click, then click any die to reroll it. Once per turn.",
	"bomb": "Click, then click any die: its face and this one become blanks.",
	"half_shields_to_swords": "Adds half your defend total to this colour.",
}

const TYPE_COLORS := {
	Type.BLANK: Color.WHITE,
	Type.ATTACK: Color.RED,
	Type.DEFEND: Color.GRAY,
	Type.HEAL: Color.GREEN,
	Type.MAGIC: Color(0.35, 0.55, 1.0),
}

const TYPE_NAMES := {
	Type.BLANK: "", Type.ATTACK: "Attack", Type.DEFEND: "Defend",
	Type.HEAL: "Heal", Type.MAGIC: "Magic",
}

var id: String
var type: int

# Per-turn state, cleared by reset_turn().
var used := false
var cashed := 0
var winds_inc := 1

# Springs only: kept across turns.
var winds := 0


func _init(p_id: String, p_type: int) -> void:
	id = p_id
	type = Type.BLANK if id in UTILITY else p_type


func texture() -> Texture2D:
	return load("res://art/dice/%s.png" % SPRITES.get(id, id))


func color() -> Color:
	return TYPE_COLORS[type]


func description() -> String:
	var text: String = "+%d." % NUMBERS[id] if NUMBERS.has(id) else DESCRIPTIONS.get(id, id)
	if TYPE_NAMES[type] != "":
		text = "%s: %s" % [TYPE_NAMES[type], text]
	if id == "spring":
		text += " (%d wound)" % winds
	return text


func is_targeted() -> bool:
	return id in TARGETED


func reset_turn() -> void:
	used = false
	cashed = 0
	winds_inc = 1


## -1 means the face has no roll effect.
func priority() -> int:
	if NUMBERS.has(id):
		return 1
	match id:
		"blank_bonus":
			return 0
		"spring":
			return 1
		"even", "odd":
			return 2
		"half_shields_to_swords":
			return 3
	return -1


func apply(total: int, creature: Creature) -> int:
	if NUMBERS.has(id):
		return total + NUMBERS[id]
	match id:
		"blank_bonus":
			return total + 3 * creature.blank_count
		"spring":
			return total + cashed
		"even":
			return total * 2 if total % 2 == 0 else total
		"odd":
			return total * 3 if total % 2 == 1 else total
		"half_shields_to_swords":
			return total + creature.totals[Type.DEFEND] / 2
	return total

class_name Face
extends RefCounted
## One side of a die. `type` picks which total it feeds, `id` picks what it does.
## Faces live on their die between turns, so springs keep their winds and clocks their count.

enum Type { BLANK = -1, ATTACK, DEFEND, HEAL, MAGIC }

## Totals are built tier by tier: 0 = blank bonus, 1 = numbers and springs, 2 = pair,
## 3 = multipliers (even, odd, clock), 4 = converters.
const TIERS := [0, 1, 2, 3, 4]

const NUMBERS := {
	"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6,
	"seven": 7, "eight": 8, "nine": 9, "ten": 10, "eleven": 11, "twelve": 12,
}

## Normal loot after a fight. Weights from the Unity "Dice Sides" objects; higher = more common.
const LOOT_WEIGHTS := {
	"one": 100, "two": 90, "three": 85, "four": 80, "five": 75, "six": 70,
	"blank": 80, "blank_bonus": 30, "even": 50, "odd": 50, "reroll": 30, "bomb": 20, "spring": 10,
}

## High-tier loot after a boss: that tier's two numbers plus these special faces.
const TIER_NUMBERS := {2: ["seven", "eight"], 3: ["nine", "ten"], 4: ["eleven", "twelve"]}
const TIER_NUMBER_WEIGHT := 100
const SPECIAL_WEIGHTS := {
	"clock": 30, "echo": 30, "pair": 30, "mirror": 30, "spring_winder": 30, "half_shields_to_swords": 30,
}

## Faces that stay white and never feed a total directly.
const UTILITY := ["blank", "bomb", "reroll", "spring_winder", "mirror", "echo"]

## Faces you click, then click a target die.
const TARGETED := ["bomb", "reroll", "echo"]

const CLOCK_START := 3

## Face ids whose sprite file name differs from the id.
const SPRITES := {
	"blank_bonus": "blank3", "even": "even2", "odd": "odd3",
	"spring_winder": "springs", "half_shields_to_swords": "halfshieldtosword",
}

## Faces with no sprite yet. They show this name on a blank face.
const PLACEHOLDERS := {"clock": "Clock", "echo": "Echo", "pair": "Pair", "mirror": "Mirror"}

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
	"clock": "Counts down each time it is rolled. At zero it triples this colour's total and restarts.",
	"echo": "Click, then click any die: it rerolls, and its old face still counts this turn.",
	"pair": "Number faces of this colour that show two or more times count double.",
	"mirror": "Copies the face showing on the die to its left.",
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
var clock_struck := false

# Kept across turns.
var winds := 0
var countdown := CLOCK_START


func _init(p_id: String, p_type: int) -> void:
	id = p_id
	type = Type.BLANK if id in UTILITY else p_type


## Number face for a value, e.g. 3 -> "three". Capped at twelve.
static func number_id(value: int) -> String:
	return NUMBERS.keys()[clampi(value, 1, 12) - 1]


func texture() -> Texture2D:
	if PLACEHOLDERS.has(id):
		return load("res://art/dice/blank.png")
	return load("res://art/dice/%s.png" % SPRITES.get(id, id))


## Text drawn on the face: placeholder names, spring winds, clock countdown.
func caption() -> String:
	match id:
		"spring":
			return str(winds)
		"clock":
			return "Clock\n%d" % countdown
	return PLACEHOLDERS.get(id, "")


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
	clock_struck = false


## Called when this face lands face up.
func on_rolled() -> void:
	match id:
		"spring":
			winds += winds_inc
		"clock":
			countdown -= 1
			if countdown <= 0:
				clock_struck = true
				countdown = CLOCK_START


## -1 means the face has no roll effect.
func priority() -> int:
	if NUMBERS.has(id):
		return 1
	match id:
		"blank_bonus":
			return 0
		"spring":
			return 1
		"pair":
			return 2
		"even", "odd", "clock":
			return 3
		"half_shields_to_swords":
			return 4
	return -1


## `faces` is everything counting for the creature this turn, after mirrors and echoes.
func apply(total: int, creature: Creature, faces: Array[Face]) -> int:
	if NUMBERS.has(id):
		return total + NUMBERS[id]
	match id:
		"blank_bonus":
			return total + 3 * creature.blank_count
		"spring":
			return total + cashed
		"pair":
			var counts := {}
			for f in faces:
				if f.type == type and NUMBERS.has(f.id):
					counts[f.id] = counts.get(f.id, 0) + 1
			for number in counts:
				if counts[number] >= 2:
					total += NUMBERS[number] * counts[number]
			return total
		"even":
			return total * 2 if total % 2 == 0 else total
		"odd":
			return total * 3 if total % 2 == 1 else total
		"clock":
			return total * 3 if clock_struck else total
		"half_shields_to_swords":
			return total + creature.totals[Type.DEFEND] / 2
	return total

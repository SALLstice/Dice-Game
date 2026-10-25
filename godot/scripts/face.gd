class_name Face
extends RefCounted
## One side of a die. `type` picks which total it feeds, `id` picks what it does.

enum Type { BLANK = -1, ATTACK, DEFEND, HEAL, MAGIC }

## Totals are built tier by tier, same as the Unity version:
## 0 = blank bonus, 1 = numbers, 2 = even/odd multipliers.
const TIERS := [0, 1, 2]

const NUMBERS := {
	"one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6,
	"seven": 7, "eight": 8, "nine": 9, "ten": 10, "eleven": 11, "twelve": 12,
}

## Face ids whose sprite file name differs from the id.
const SPRITES := {"blank_bonus": "blank3", "even": "even2", "odd": "odd3"}

const TYPE_COLORS := {
	Type.BLANK: Color.WHITE,
	Type.ATTACK: Color.RED,
	Type.DEFEND: Color.GRAY,
	Type.HEAL: Color.GREEN,
	Type.MAGIC: Color(0.35, 0.55, 1.0),
}

var id: String
var type: int


func _init(p_id: String, p_type: int) -> void:
	id = p_id
	type = p_type


func texture() -> Texture2D:
	return load("res://art/dice/%s.png" % SPRITES.get(id, id))


func color() -> Color:
	return TYPE_COLORS[type]


## -1 means the face has no roll effect.
func priority() -> int:
	if NUMBERS.has(id):
		return 1
	match id:
		"blank_bonus":
			return 0
		"even", "odd":
			return 2
	return -1


func apply(total: int, creature: Creature) -> int:
	if NUMBERS.has(id):
		return total + NUMBERS[id]
	match id:
		"blank_bonus":
			return total + 3 * creature.blank_count
		"even":
			return total * 2 if total % 2 == 0 else total
		"odd":
			return total * 3 if total % 2 == 1 else total
	return total

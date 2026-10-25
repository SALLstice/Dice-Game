class_name Loot
extends RefCounted
## The faces offered after a kill, and the scrap you get for skipping them.
## Rarer faces and colours leave less scrap, as in the Unity invPanelScript.

const COUNT := 3
const SCRAP_PER_FACE := 200
const UTILITY_SCRAP_COST := 100

const TYPE_WEIGHTS := {
	Face.Type.ATTACK: 100, Face.Type.DEFEND: 50, Face.Type.HEAL: 20, Face.Type.MAGIC: 10,
}

var faces: Array[Face] = []
var scrap := SCRAP_PER_FACE * COUNT


func _init() -> void:
	for i in COUNT:
		var id: String = _weighted_pick(Face.LOOT_WEIGHTS)
		scrap -= Face.LOOT_WEIGHTS[id]
		var type := Face.Type.BLANK
		if id in Face.UTILITY:
			scrap -= UTILITY_SCRAP_COST
		else:
			type = _weighted_pick(TYPE_WEIGHTS)
			scrap -= TYPE_WEIGHTS[type]
		faces.append(Face.new(id, type))


static func _weighted_pick(weights: Dictionary) -> Variant:
	var total := 0
	for w in weights.values():
		total += w
	var roll := randi() % total
	for key in weights:
		roll -= weights[key]
		if roll < 0:
			return key
	return weights.keys()[0]

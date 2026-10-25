class_name Die
extends RefCounted

const BLANK_IDS := ["blank", "blank", "blank", "blank", "blank", "blank"]
const BLANK_TYPES := [-1, -1, -1, -1, -1, -1]

var faces: Array[Face] = []
var showing := 0


func _init(ids: Array, types: Array) -> void:
	for i in ids.size():
		faces.append(Face.new(ids[i], types[i]))


func roll() -> void:
	showing = randi() % faces.size()


func current() -> Face:
	return faces[showing]


func set_current(face: Face) -> void:
	faces[showing] = face

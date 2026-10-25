class_name Die
extends RefCounted

var faces: Array[Face] = []
var showing := 0


func _init(ids: Array, types: Array) -> void:
	for i in ids.size():
		faces.append(Face.new(ids[i], types[i]))


func roll() -> void:
	showing = randi() % faces.size()


func current() -> Face:
	return faces[showing]

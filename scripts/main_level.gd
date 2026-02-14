extends Node3D
class_name MainLevel

@export var resting_places: Array[RestingPlace]

@onready var nositka: Stretcher = $Nositka

func _enter_tree() -> void:
	global.resting_places = resting_places

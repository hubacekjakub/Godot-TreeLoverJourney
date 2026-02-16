extends Node3D
class_name MainLevel

@export var resting_places: Array[RestingPlace]

@onready var nositka: Stretcher = $Stretcher

func _enter_tree() -> void:
	Global.set_resting_places(resting_places)
	

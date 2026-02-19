extends Node3D
class_name Campfire

var visibility_distance: float = 15.0

func _enter_tree() -> void:
	UnitDirector.register_campfire(self)

func _ready() -> void:
	pass

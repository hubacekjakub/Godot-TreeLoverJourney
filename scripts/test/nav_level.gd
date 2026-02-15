extends Node3D

@onready var point_a: Node3D = $PointA
@onready var point_b: Node3D = $PointB
@onready var character_body_3d: NavAgent = $CharacterBody3D
@onready var camera_3d: Camera3D = $Camera3D

@export var RAY_LENGTH = 1000.0

func _ready() -> void:
	character_body_3d.set_movement_target(point_b.global_position)	

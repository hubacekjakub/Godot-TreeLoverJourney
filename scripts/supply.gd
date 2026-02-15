extends Area3D
class_name Supply

@export var value: int = 1
@export var color_active : Color = Color("b85306")
@export var color_unactive : Color = Color("5b2903")

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D

var material: StandardMaterial3D


	
func _ready() -> void:
	material = csg_sphere_3d.material.duplicate()
	csg_sphere_3d.material_override = material

func activate():
	material.albedo_color = color_active
	
func deactivate():
	material.albedo_color = color_unactive
	

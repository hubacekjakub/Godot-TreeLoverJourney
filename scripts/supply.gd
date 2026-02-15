extends Area3D
class_name Supply

@export var value: int = 1
@export var color_active : Color = Color("b85306")
@export var color_unactive : Color = Color("5b2903")

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D

var material: StandardMaterial3D
var active: bool = false



func _ready() -> void:
	material = csg_sphere_3d.material.duplicate()
	csg_sphere_3d.material_override = material

func activate():
	active = true
	material.albedo_color = color_active
	
func deactivate():
	active = false
	material.albedo_color = color_unactive
	
func start_collecting():
	print("resource collected")
	await get_tree().create_timer(2).timeout
	queue_free()
	

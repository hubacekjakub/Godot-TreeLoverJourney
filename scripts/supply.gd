extends Area3D
class_name Supply

@export_category("Visual Setup")
@export var value: int = 1
@export var color_active : Color = Color("b85306")
@export var color_unactive : Color = Color("5b2903")

@export_category("Functional Setup")
@export var collection_time: float = 2.0

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collecting_timer: Timer = $CollectingTimer
#@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var progress_bar: Control = $ProgressBar

var material: StandardMaterial3D
var active: bool = false

var progress_tween: Tween = null

func _ready() -> void:
	material = csg_sphere_3d.material.duplicate()
	csg_sphere_3d.material_override = material
	progress_bar.visible = false

func activate():
	active = true
	material.albedo_color = color_active
	
func deactivate():
	active = false
	material.albedo_color = color_unactive
	
func start_collecting():
	print("resource collected")
	
	if progress_tween == null:
		progress_bar.visible = true
		progress_tween = get_tree().create_tween()
		#progress_tween.tween_property(progress_bar, "", 100, collection_time)
		progress_tween.tween_method(progress_bar.set_progress, 0, 100, collection_time)
		progress_tween.tween_callback(self.queue_free)
			
	#await get_tree().create_timer(collection_time).timeout
	#queue_free()
	

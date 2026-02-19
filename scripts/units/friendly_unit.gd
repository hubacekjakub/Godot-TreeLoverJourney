extends BaseUnit
class_name FriendlyUnit

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D

@export var color_active = Color("00abd1")
@export var color_unactive = Color("005acb")

var material: StandardMaterial3D
var is_active: bool = false
var is_lost: bool = false

func _enter_tree() -> void:
	UnitDirector.register_unit(self)

func _ready() -> void:
	super._ready()
	material = csg_sphere_3d.material.duplicate()
	csg_sphere_3d.material_override = material

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalBus.on_unit_selected.emit(self)

func activate() -> void:
	is_active = true
	material.albedo_color = color_active

func deactivate() -> void:
	is_active = false
	material.albedo_color = color_unactive

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	print(name + " entered screen!")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print(name + " exited screen!")
	is_lost = true
	set_physics_process(false)
	UnitDirector.register_lost_unit(self)

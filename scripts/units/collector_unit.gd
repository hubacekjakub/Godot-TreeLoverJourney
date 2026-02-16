extends CharacterBody3D
class_name CollectorUnit

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D

@export var movement_speed: float = 4.0
@export var RAY_LENGTH = 10000.0
@export var fall_acceleration = 500

@export var color_active = Color("00abd1")
@export var color_unactive = Color("005acb")

var material: StandardMaterial3D
var is_active: bool = false

func _enter_tree() -> void:
	UnitDirector.register_unit(self)

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	material = csg_sphere_3d.material.duplicate()
	csg_sphere_3d.material_override = material

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		var fall_velocity = Vector3(0, self.velocity.y - (fall_acceleration * delta), 0)
		_on_velocity_computed(fall_velocity)
		return
		
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalBus.on_unit_selected.emit(self)
		
func activate() -> void:
	is_active = true
	material.albedo_color = color_active

func deactivate() -> void:
	is_active = false
	material.albedo_color = color_unactive

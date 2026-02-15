extends CharacterBody3D
class_name NavAgent

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@export var RAY_LENGTH = 10000.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var mouse_pos = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(mouse_pos)
		var to = camera.project_ray_normal(mouse_pos) * 10000
		var drop_plane = Plane(Vector3.UP, global_position.y)
		var cursor_3d_pos = drop_plane.intersects_ray(from, to)
		
		set_movement_target(cursor_3d_pos)
	

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta: float) -> void:
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

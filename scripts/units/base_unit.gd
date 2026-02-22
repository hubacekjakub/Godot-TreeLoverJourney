extends CharacterBody3D
class_name BaseUnit

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

@export var movement_speed: float = 4.0
var fall_acceleration = 500
@export var is_enabled: bool = false

var is_moving: bool = false
var is_gathering: bool = false

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	if not is_enabled:
		print("BaseUnit", name, "is disabled")
		return

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		var fall_velocity = Vector3(0, self.velocity.y - (fall_acceleration * delta), 0)
		_on_velocity_computed(fall_velocity)
		return

	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		is_moving = false
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
	is_moving = true

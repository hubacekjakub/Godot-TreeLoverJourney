extends Camera3D
class_name CinematicCamera

enum State {
	FOLLOW_TARGET,
	FREE_LOOK
}

@export var target_node: Node3D
@export var follow_speed: float = 5.0
@export var free_look_speed: float = 10.0
@export var mouse_sensitivity: float = 0.002

var current_state: State = State.FOLLOW_TARGET
var _pitch: float = 0.0
var _yaw: float = 0.0

func _ready() -> void:
	print("CinematicCamera: Initialized name=", name, " target_node=", target_node)

	if not target_node:
		# Fallback: try to find the stretcher's camera target marker by path or name
		target_node = get_node_or_null("../Day/Path3D/PathFollow3D/Stretcher/CameraTargetMarker")
		if target_node:
			print("CinematicCamera: Found target_node via fallback path.")
		else:
			# Even more aggressive fallback if the path is slightly different
			var nodes = get_tree().get_nodes_in_group("CameraTarget") # Assuming we might add a group
			if nodes.size() > 0:
				target_node = nodes[0]
				print("CinematicCamera: Found target_node via group fallback.")

	if current_state == State.FREE_LOOK:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Debug toggle for editor
	if OS.has_feature("editor") and event.is_action_pressed("ui_focus_next"): # Tab key by default
		toggle_state()

	if current_state == State.FREE_LOOK:
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_yaw -= event.relative.x * mouse_sensitivity
			_pitch -= event.relative.y * mouse_sensitivity
			_pitch = clamp(_pitch, -PI / 2, PI / 2)

			rotation.y = _yaw
			rotation.x = _pitch
			rotation.z = 0

		if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	match current_state:
		State.FOLLOW_TARGET:
			if target_node:
				global_transform = global_transform.interpolate_with(target_node.global_transform, follow_speed * delta)
				_sync_rotation_variables()
			else:
				if Engine.get_process_frames() % 60 == 0:
					print("CinematicCamera: No target_node assigned!")
		State.FREE_LOOK:
			_handle_free_look_movement(delta)

func _handle_free_look_movement(delta: float) -> void:
	var move_dir := Vector3.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		move_dir += -transform.basis.z
	if Input.is_physical_key_pressed(KEY_S):
		move_dir += transform.basis.z
	if Input.is_physical_key_pressed(KEY_A):
		move_dir += -transform.basis.x
	if Input.is_physical_key_pressed(KEY_D):
		move_dir += transform.basis.x

	# Vertical movement
	if Input.is_physical_key_pressed(KEY_E) or Input.is_physical_key_pressed(KEY_SPACE):
		move_dir += Vector3.UP
	if Input.is_physical_key_pressed(KEY_Q) or Input.is_physical_key_pressed(KEY_CTRL):
		move_dir += Vector3.DOWN

	move_dir = move_dir.normalized()

	# Sprinting
	var speed_multiplier = 3.0 if Input.is_physical_key_pressed(KEY_SHIFT) else 1.0

	global_position += move_dir * free_look_speed * speed_multiplier * delta

func toggle_state() -> void:
	if current_state == State.FOLLOW_TARGET:
		current_state = State.FREE_LOOK
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_sync_rotation_variables()
	else:
		current_state = State.FOLLOW_TARGET
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _sync_rotation_variables() -> void:
	var euler = rotation
	_yaw = euler.y
	_pitch = euler.x

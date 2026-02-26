extends Node

var mouse_marker_scene: PackedScene = preload("uid://26t2mwuomtis")

var day_units: Array[FriendlyUnit]
var night_units: Array[FriendlyUnit]

var lost_units: Array[FriendlyUnit]
var active_unit: FriendlyUnit
var stretcher: Stretcher
var campfire: Campfire

var mouse_marker: Node3D = null
var marker_timer: SceneTreeTimer = null

func _ready() -> void:
	SignalBus.on_unit_selected.connect(handle_unit_selected)
	SignalBus.on_night_transition_start.connect(handle_night_transition_start)
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)
	mouse_marker = mouse_marker_scene.instantiate()
	mouse_marker.visible = false
	add_child(mouse_marker)

func _unhandled_input(event: InputEvent) -> void:
	if not active_unit:
		return

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		SignalBus.on_unit_deselected.emit(active_unit)
		active_unit.deactivate()
		active_unit = null

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		handle_right_click()

func handle_right_click() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = camera.project_ray_normal(mouse_pos) * 10000
	var drop_plane = Plane(Vector3.UP, get_ground_position().y)
	var cursor_3d_pos = drop_plane.intersects_ray(from, to)
	show_marker_at(cursor_3d_pos)
	set_unit_movement_target(cursor_3d_pos)

func show_marker_at(position: Vector3) -> void:
	mouse_marker.global_position = position
	show_marker()
	if marker_timer and marker_timer.time_left > 0:
		marker_timer.timeout.disconnect(hide_marker)
	marker_timer = get_tree().create_timer(2)
	marker_timer.timeout.connect(hide_marker)

func get_ground_position() -> Vector3:
	if NightDirector.is_night_active:
		assert(campfire)
		return campfire.global_position
	else:
		assert(stretcher)
		return stretcher.global_position

func get_visibility_distance() -> float:
	if NightDirector.is_night_active:
		assert(campfire)
		return campfire.visibility_distance
	else:
		assert(stretcher)
		return stretcher.visibility_distance

func register_unit(new_unit: FriendlyUnit) -> void:
	if new_unit.type == FriendlyUnit.UnitType.DAY:
		day_units.append(new_unit)
	else:
		night_units.append(new_unit)

func register_stretcher(new_stretcher: Stretcher) -> void:
	stretcher = new_stretcher

func register_campfire(new_campfire: Campfire) -> void:
	campfire = new_campfire

func register_lost_unit(lost_unit: FriendlyUnit) -> void:
	lost_units.append(lost_unit)
	SignalBus.on_unit_lost.emit(lost_unit)
	if lost_unit == active_unit:
		active_unit = null

func handle_unit_selected(selected_unit: FriendlyUnit) -> void:
	active_unit = selected_unit

	for unit in day_units:
		if unit == selected_unit:
			unit.activate()
		else:
			unit.deactivate()

	for unit in night_units:
		if unit == selected_unit:
			unit.activate()
		else:
			unit.deactivate()

func handle_night_end(_success: bool) -> void:
	day_units.clear()
	night_units.clear()
	lost_units.clear()
	active_unit = null
	stretcher = null
	campfire = null

func deselect_all_units() -> void:
	for unit in day_units:
		unit.deactivate()
	for unit in night_units:
		unit.deactivate()

func set_unit_movement_target(cursor_3d_pos: Vector3) -> void:
	var base_position: Vector3 = get_ground_position()
	var distance_from_cursor: Vector3 = (cursor_3d_pos - base_position).limit_length(get_visibility_distance())
	var clamped_location: Vector3 = base_position + distance_from_cursor

	if active_unit:
		active_unit.set_movement_target(clamped_location)

func show_marker() -> void:
	mouse_marker.visible = true

func hide_marker() -> void:
	mouse_marker.visible = false

func set_all_units_state(unit_type: FriendlyUnit.UnitType, state: bool) -> void:
	if unit_type == FriendlyUnit.UnitType.DAY:
		for unit in day_units:
			unit.is_enabled = state
	elif unit_type == FriendlyUnit.UnitType.NIGHT:
		for unit in night_units:
			unit.is_enabled = state

func handle_night_transition_start() -> void:
	deselect_all_units()
	active_unit = null
	set_all_units_state(FriendlyUnit.UnitType.DAY, false)

func handle_night_start(_level: int) -> void:
	set_all_units_state(FriendlyUnit.UnitType.NIGHT, true)

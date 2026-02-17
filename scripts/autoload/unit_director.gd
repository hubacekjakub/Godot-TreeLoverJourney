extends Node

var units: Array[CollectorUnit]
var lost_units: Array[CollectorUnit]
var active_unit: CollectorUnit
var stretcher: Stretcher

func _ready() -> void:
	SignalBus.on_unit_selected.connect(handle_unit_selected)


func _unhandled_input(event: InputEvent) -> void:
	if not active_unit:
		return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:		
		SignalBus.on_unit_deselected.emit(active_unit)
		active_unit.deactivate()
		active_unit = null
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var mouse_pos = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(mouse_pos)
		var to = camera.project_ray_normal(mouse_pos) * 10000
		var drop_plane = Plane(Vector3.UP, stretcher.global_position.y)
		var cursor_3d_pos = drop_plane.intersects_ray(from, to)

		set_unit_movement_target(cursor_3d_pos)

func register_unit(new_unit: CollectorUnit) -> void:
	units.append(new_unit)

func register_stretcher(new_stretcher: Stretcher) -> void:
	stretcher = new_stretcher

func register_lost_unit(lost_unit: CollectorUnit) -> void:
	lost_units.append(lost_unit)
	if lost_unit == active_unit:
		active_unit = null

func handle_unit_selected(selected_unit: CollectorUnit) -> void:
	print("unit selected: ", selected_unit)
	active_unit = selected_unit

	for unit in units:
		if unit == selected_unit:
			unit.activate()
		else:
			unit.deactivate()
			
func deselect_all_units() -> void:
	for unit in units:
		unit.deactivate()

func set_unit_movement_target(cursor_3d_pos: Vector3) -> void:
	var stretcher_position: Vector3 = stretcher.global_position
	var distance_from_cursor: Vector3 = (cursor_3d_pos - stretcher_position).limit_length(stretcher.visibility_distance)
	var clamped_location: Vector3 = stretcher.global_position + distance_from_cursor

	assert(active_unit)

	if active_unit:
		active_unit.set_movement_target(clamped_location)

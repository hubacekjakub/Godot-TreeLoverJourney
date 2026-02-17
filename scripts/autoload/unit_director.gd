extends Node

var units: Array[CollectorUnit]
var active_unit: CollectorUnit
var stretcher: Stretcher

func _ready() -> void:
	SignalBus.on_unit_selected.connect(handle_unit_selected)


func _unhandled_input(event: InputEvent) -> void:
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

func handle_unit_selected(selected_unit: CollectorUnit) -> void:
	print("unit selected: ", selected_unit)
	active_unit = selected_unit

	for unit in units:
		if unit == selected_unit:
			unit.activate()
		else:
			unit.deactivate()

func set_unit_movement_target(cursor_3d_pos: Vector3) -> void:
	var stretcher_position: Vector3 = stretcher.global_position
	var direction_to_cursor: Vector3 = stretcher_position.direction_to(cursor_3d_pos)
	var max_avaliable_location: Vector3 = direction_to_cursor * 15

	if active_unit:
		active_unit.set_movement_target(stretcher.global_position + max_avaliable_location)

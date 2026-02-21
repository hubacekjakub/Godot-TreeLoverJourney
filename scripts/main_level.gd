extends Node3D
class_name Level

@export var level: int = 1
@export var resting_places: Array[RestingPlace]
@export var begin_wait_time: float = 3.5
@export var nositka: Stretcher
@export var level_camera: Camera3D

var current_resting_place_index: int = 0
var camera_tween: Tween = null

func _ready() -> void:
	SignalBus.resting_place_reached.connect(handle_on_resting_place_reached)
	await get_tree().create_timer(begin_wait_time).timeout
	if resting_places.size() > 0:
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])

func handle_on_resting_place_reached():
	#print("lets wait 2 seconds before going further")
	#await get_tree().create_timer(0.5).timeout
	current_resting_place_index = current_resting_place_index+1

	if current_resting_place_index < resting_places.size():
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])
		print("sending new resting place: ", current_resting_place_index)
	else:
		SignalBus.on_night_transition_start.emit()
		start_night_transition()

		print("there is no resting place")

# prepares level for night gameplay
func start_night_transition() -> void:
	var night_location_transform = level_camera.global_transform
	level_camera.transform = nositka.get_camera_transform()
	level_camera.current = true

	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(level_camera, "transform", night_location_transform, 1.5).set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_callback(self.night_camera_move_finished)

func night_camera_move_finished() -> void:
	print("camera move to night location finished")
	SignalBus.on_night_transition_finished.emit()

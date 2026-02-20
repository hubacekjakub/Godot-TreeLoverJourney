extends Node3D
class_name Level

@export var level: int = 1
@export var resting_places: Array[RestingPlace]
@export var night_camera: Camera3D
@export var begin_wait_time: float = 3.5

@onready var nositka: Stretcher = $Stretcher

var current_resting_place_index: int = 0

func _ready() -> void:
	
	
	#SignalBus.on_night_start.connect(handle_night_start)
	#SignalBus.resting_place_reached.connect(handle_on_resting_place_reached)
	await get_tree().create_timer(begin_wait_time).timeout
	SignalBus.on_night_end.emit(true)
	#if resting_places.size() > 0:
	#	SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])

func handle_night_start(_level: int) -> void:
	night_camera.current = true

func handle_on_resting_place_reached():
	print("lets wait 2 seconds before going further")
	await get_tree().create_timer(2).timeout

	current_resting_place_index = current_resting_place_index+1

	if current_resting_place_index < resting_places.size():
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])
		print("sending new resting place: ", current_resting_place_index)
	else:
		SignalBus.on_night_start.emit(1)
		print("there is no resting place")

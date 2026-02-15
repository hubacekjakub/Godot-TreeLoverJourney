extends Node

@export var resting_places: Array[RestingPlace]
@export var begin_wait_time: float = 3.5

var current_resting_place_index: int = 0

func _ready() -> void:
	SignalBus.resting_place_reached.connect(handle_on_resting_place_reached)
	await get_tree().create_timer(begin_wait_time).timeout

	if resting_places.size() > 0:
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])

func handle_on_resting_place_reached():
	print("lets wait 2 seconds before going further")
	await get_tree().create_timer(2).timeout

	current_resting_place_index = current_resting_place_index+1

	if current_resting_place_index < resting_places.size():
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])
		print("sending new resting place: ", current_resting_place_index)
	else:
		print("there is no resting place")


func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func set_resting_places(new_resting_places: Array) -> void:
	resting_places = new_resting_places
	SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])

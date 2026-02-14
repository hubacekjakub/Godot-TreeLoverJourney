extends Node

@export var resting_places: Array[RestingPlace]

var current_resting_place_index: int = 0

func _ready() -> void:
	SignalBus.resting_place_reached.connect(handle_on_resting_place_reached)
	await get_tree().create_timer(2).timeout

	if resting_places.size() > 0:
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])

func handle_on_resting_place_reached():
	print("lets wait 5 seconds before going further")
	await get_tree().create_timer(5).timeout

	current_resting_place_index = current_resting_place_index+1

	if current_resting_place_index < resting_places.size():
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])
		print("sending new resting place: ", current_resting_place_index)
	else:
		print("there is no resting place")

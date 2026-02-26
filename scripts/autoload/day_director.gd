extends Node

var resting_places: Array[RestingPlace] = []
var current_resting_place_index: int = 0

func _ready() -> void:
	SignalBus.on_day_start.connect(handle_day_start)
	SignalBus.on_day_end.connect(handle_day_end)
	SignalBus.resting_place_reached.connect(handle_resting_place_reached)

func initialize_day(places: Array[RestingPlace]) -> void:
	resting_places = places
	current_resting_place_index = 0

func handle_day_start() -> void:
	if resting_places.size() > 0:
		SignalBus.new_resting_place_set.emit(resting_places[0])
	else:
		SignalBus.on_day_end.emit()

func handle_resting_place_reached() -> void:
	current_resting_place_index += 1
	if current_resting_place_index < resting_places.size():
		SignalBus.new_resting_place_set.emit(resting_places[current_resting_place_index])
	else:
		SignalBus.on_day_end.emit()

func handle_day_end() -> void:
	resting_places.clear()
	current_resting_place_index = 0

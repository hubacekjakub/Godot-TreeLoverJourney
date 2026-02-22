extends Node

func _ready() -> void:
	SignalBus.on_day_start.connect(handle_day_start)
	SignalBus.on_day_end.connect(handle_day_end)

func handle_day_start() -> void:
	pass


func handle_day_end() -> void:
	pass

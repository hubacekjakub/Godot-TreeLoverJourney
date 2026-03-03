extends Node

var stretcher: Stretcher

func _ready() -> void:
	SignalBus.on_day_start.connect(_on_day_start)

func register_stretcher(new_stretcher: Stretcher) -> void:
	stretcher = new_stretcher

func _on_day_start() -> void:
	if stretcher:
		stretcher.march_finished.connect(_on_march_finished, CONNECT_ONE_SHOT)
		stretcher.start_march()

func _on_march_finished() -> void:
	SignalBus.on_day_end.emit()

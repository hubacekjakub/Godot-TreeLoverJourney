extends Node

var collected_supplies: Array[int] = [0, 0]
var had_supplies: bool = false

func reset() -> void:
	collected_supplies = [0, 0]
	had_supplies = false

func supply_collected(supply: Supply, amount: int) -> void:
	collected_supplies[supply.type] = collected_supplies[supply.type] + amount
	had_supplies = true
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_collected.emit(supply, amount)

func supply_stolen(supply: Supply, amount: int) -> void:
	collected_supplies[supply.type] = max(collected_supplies[supply.type] - amount, 0)
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_stolen.emit(supply, amount)
	_check_lose_condition()

func _check_lose_condition() -> void:
	if not NightDirector.is_night_active:
		return
	if not had_supplies:
		return
	if collected_supplies[0] <= 0 and collected_supplies[1] <= 0:
		SignalBus.on_night_end.emit(false)

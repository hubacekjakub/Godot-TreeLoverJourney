extends Node

var collected_supplies: Array[int] = [0, 0]

func supply_collected(supply: Supply, amount: int) -> void:
	print("supply: supply collected")
	collected_supplies[supply.type] = collected_supplies[supply.type] + amount
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_collected.emit(supply, amount)

func supply_stolen(supply: Supply, amount: int) -> void:
	print("supply: supply stolen")
	collected_supplies[supply.type] = max(collected_supplies[supply.type] - amount, 0)
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_stolen.emit(supply, amount)

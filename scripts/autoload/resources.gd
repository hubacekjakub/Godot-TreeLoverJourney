extends Node

#
var collected_resources: Array[int] = [0, 0]

func resource_collected(resource: Supply.ResoruceType, amount: int) -> void:
	print("Resource: resource collected")
	collected_resources[resource] = collected_resources[resource] + amount
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_collected.emit(resource, amount)

func resource_stolen(resource: Supply.ResoruceType, amount: int) -> void:
	print("Resource: resource stolen")
	collected_resources[resource] = max(collected_resources[resource] - amount, 0)
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_stolen.emit(resource, amount)

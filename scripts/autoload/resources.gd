extends Node

#
var collected_resources: Array[int] = [0, 0]

func resource_collected(resource: Supply.ResoruceType, amount: int) -> void:
	print("Resource: resource update")
	collected_resources[resource] = collected_resources[resource] + amount
	SignalBus.on_resource_updated.emit()
	

func handle_resource_lost(resource: Supply.ResoruceType, amount: int) -> void:
	#TODO
	print("lost resource bro: ", resource, ", amount: ", amount)

extends Node

var _amounts: Dictionary = {}
var had_supplies: bool = false

func reset() -> void:
	_amounts = {Supply.SupplyType.BERRY: 0, Supply.SupplyType.WOOD: 0}
	had_supplies = false

func get_amount(type: Supply.SupplyType) -> int:
	return _amounts.get(type, 0)

func can_spend(type: Supply.SupplyType, amount: int) -> bool:
	return get_amount(type) >= amount

func spend(type: Supply.SupplyType, amount: int) -> bool:
	if not can_spend(type, amount):
		return false
	_amounts[type] -= amount
	SignalBus.on_supply_updated.emit()
	return true

func supply_collected(supply: Supply, amount: int) -> void:
	_amounts[supply.type] = get_amount(supply.type) + amount
	had_supplies = true
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_collected.emit(supply, amount)

func supply_stolen(supply: Supply, amount: int) -> void:
	_amounts[supply.type] = max(get_amount(supply.type) - amount, 0)
	SignalBus.on_supply_updated.emit()
	SignalBus.on_supply_stolen.emit(supply, amount)
	_check_lose_condition()

func _check_lose_condition() -> void:
	if not NightDirector.is_night_active:
		return
	if not had_supplies:
		return
	if get_amount(Supply.SupplyType.BERRY) <= 0 and get_amount(Supply.SupplyType.WOOD) <= 0:
		SignalBus.on_night_end.emit(false)

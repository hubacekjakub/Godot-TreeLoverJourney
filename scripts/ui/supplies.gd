extends Control

@onready var wood_count: Label = %WoodCount
@onready var berries_count: Label = %BerriesCount
@onready var lost_count: Label = %LostCount

func _ready() -> void:
	SignalBus.on_supply_updated.connect(handle_supply_updated)
	SignalBus.on_unit_lost.connect(handle_lost_kakapos)

func handle_supply_updated() -> void:
	print("UI: supply update")
	berries_count.text = str(Supplies.collected_supplies[Supply.ResoruceType.BERRY])
	wood_count.text = str(Supplies.collected_supplies[Supply.ResoruceType.WOOD])

func handle_lost_kakapos(_lost_unit: FriendlyUnit) -> void:
	print("UI: kakapo lost")
	lost_count.text = str(UnitDirector.lost_units.size())

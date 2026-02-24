extends Control

@onready var wood_count: Label = %WoodCount
@onready var berries_count: Label = %BerriesCount
@onready var lost_count: Label = %LostCount

func _ready() -> void:
	SignalBus.on_supply_updated.connect(handle_supply_updated)
	SignalBus.on_unit_lost.connect(handle_lost_kakapos)

func handle_supply_updated() -> void:
	berries_count.text = str(Supplies.collected_supplies[Supply.SupplyType.BERRY])
	wood_count.text = str(Supplies.collected_supplies[Supply.SupplyType.WOOD])

func handle_lost_kakapos(_lost_unit: FriendlyUnit) -> void:
	lost_count.text = str(UnitDirector.lost_units.size())

extends Control

@onready var wood_count: Label = $MarginContainer/HFlowContainer/VFlowContainer/HFlowContainer2/WoodCount
@onready var berries_count: Label = $MarginContainer/HFlowContainer/VFlowContainer/HFlowContainer2/BerriesCount

func _ready() -> void:
	SignalBus.on_resource_updated.connect(handle_resource_updated)

func handle_resource_updated() -> void:
	print("UI: resource update")
	berries_count.text = str(Resources.collected_resources[Supply.ResoruceType.BERRY])
	wood_count.text = str(Resources.collected_resources[Supply.ResoruceType.WOOD])

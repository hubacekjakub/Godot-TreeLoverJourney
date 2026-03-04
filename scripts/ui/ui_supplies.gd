extends Control
## Resource display panel with animated feedback on supply changes.

@onready var wood_count: Label = %WoodCount
@onready var berries_count: Label = %BerriesCount
@onready var lost_count: Label = %LostCount
@onready var kakapos_count: Label = %KakaposCount
@onready var berries_icon: TextureRect = %BerriesIcon
@onready var wood_icon: TextureRect = %WoodIcon

func _ready() -> void:
	SignalBus.on_supply_updated.connect(_handle_supply_updated)
	SignalBus.on_supply_collected.connect(_handle_supply_collected)
	SignalBus.on_supply_stolen.connect(_handle_supply_stolen)
	SignalBus.on_unit_lost.connect(_handle_unit_lost)
	SignalBus.on_night_end.connect(_handle_night_end)

func _handle_supply_updated() -> void:
	berries_count.text = str(Supplies.get_amount(Supply.SupplyType.BERRY))
	wood_count.text = str(Supplies.get_amount(Supply.SupplyType.WOOD))
	_update_kakapos_count()

func _handle_supply_collected(supply: Supply, _amount: int) -> void:
	var icon := berries_icon if supply.type == Supply.SupplyType.BERRY else wood_icon
	_animate_icon_collect(icon)

func _handle_supply_stolen(supply: Supply, _amount: int) -> void:
	var icon := berries_icon if supply.type == Supply.SupplyType.BERRY else wood_icon
	_animate_icon_stolen(icon)
	_flash_panel_red()

func _handle_unit_lost(_lost_unit: FriendlyUnit) -> void:
	lost_count.text = str(UnitDirector.lost_units.size())
	_animate_label_pulse(lost_count, Color(1.0, 0.3, 0.3))
	_update_kakapos_count()

func _handle_night_end(_success: bool) -> void:
	_update_kakapos_count()

func _update_kakapos_count() -> void:
	var total := UnitDirector.day_units.size() + UnitDirector.night_units.size()
	var alive := total - UnitDirector.lost_units.size()
	kakapos_count.text = "%d / %d" % [alive, total]


func _animate_icon_collect(icon: TextureRect) -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(icon, "scale", Vector2(1.45, 1.45), 0.12).set_ease(Tween.EASE_OUT)
	await t.finished
	var t2 := create_tween()
	t2.tween_property(icon, "scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_IN)

func _animate_icon_stolen(icon: TextureRect) -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(icon, "self_modulate", Color(1.0, 0.25, 0.25), 0.12)
	await t.finished
	var t2 := create_tween()
	t2.tween_property(icon, "self_modulate", Color.WHITE, 0.3).set_ease(Tween.EASE_OUT)

func _flash_panel_red() -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(self , "self_modulate", Color(1.6, 0.6, 0.6), 0.1)
	await t.finished
	var t2 := create_tween()
	t2.tween_property(self , "self_modulate", Color.WHITE, 0.4).set_ease(Tween.EASE_OUT)

func _animate_label_pulse(label: Label, color: Color) -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(label, "self_modulate", color, 0.12)
	t.tween_property(label, "scale", Vector2(1.3, 1.3), 0.12).set_ease(Tween.EASE_OUT)
	await t.finished
	var t2 := create_tween().set_parallel(true)
	t2.tween_property(label, "self_modulate", Color.WHITE, 0.35).set_ease(Tween.EASE_OUT)
	t2.tween_property(label, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_IN)

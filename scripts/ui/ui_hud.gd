extends CanvasLayer
## Central HUD controller. Coordinates panel visibility and phase transitions.

@onready var resources_panel: Control = %ResourcesPanel
@onready var night_timer: Control = %NightTimer
@onready var phase_label: Label = %PhaseLabel
@onready var level_label: Label = %LevelLabel
@onready var roster_hbox: HBoxContainer = %RosterHBox

const KAKAPO_CARD_SCENE = preload("uid://c65k1p2x420m")

var _phase_tween: Tween = null
var _roster_cards: Array = []

func _ready() -> void:
	SignalBus.on_day_start.connect(_on_day_start)
	SignalBus.on_night_transition_start.connect(_on_night_transition_start)
	SignalBus.on_night_start.connect(_on_night_start)
	SignalBus.on_night_end.connect(_on_night_end)

	SignalBus.on_unit_registered.connect(_on_unit_registered)
	SignalBus.on_unit_selected.connect(_on_unit_selected)
	SignalBus.on_unit_deselected.connect(_on_unit_deselected)

	# Initial state
	_set_phase_label("DAY")
	_update_level_label(Global.current_level_index)

	for unit in UnitDirector.day_units:
		_on_unit_registered(unit)
	for unit in UnitDirector.night_units:
		_on_unit_registered(unit)

func _on_unit_registered(unit: FriendlyUnit) -> void:
	if unit.type != FriendlyUnit.UnitType.DAY:
		return
	var card = KAKAPO_CARD_SCENE.instantiate()
	roster_hbox.add_child(card)
	card.setup(unit)
	_roster_cards.append(card)

func _on_unit_selected(unit: FriendlyUnit) -> void:
	for card in _roster_cards:
		if is_instance_valid(card):
			card.set_active(card.unit == unit)

func _on_unit_deselected(_unit: FriendlyUnit) -> void:
	for card in _roster_cards:
		if is_instance_valid(card):
			card.set_active(false)


func _on_day_start() -> void:
	_set_phase_label("DAY")


func _on_night_transition_start() -> void:
	_set_phase_label("NIGHT IS FALLING…")


func _on_night_start(level: int) -> void:
	_set_phase_label("NIGHT")
	_update_level_label(level - 1)


func _on_night_end(_success: bool) -> void:
	pass # LevelResult overlay takes over


func _set_phase_label(text: String) -> void:
	if not is_node_ready():
		return
	if _phase_tween:
		_phase_tween.kill()
	_phase_tween = create_tween().set_parallel(true)
	_phase_tween.tween_property(phase_label, "modulate:a", 0.0, 0.15).set_ease(Tween.EASE_IN)
	await _phase_tween.finished
	phase_label.text = text
	_phase_tween = create_tween().set_parallel(true)
	_phase_tween.tween_property(phase_label, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)

func _update_level_label(level_index: int) -> void:
	if not is_node_ready():
		return
	level_label.text = "LEVEL  %d" % (level_index + 1)

extends MarginContainer
## Shows info about the currently selected kakapo unit.

@onready var unit_type_label: Label = %UnitTypeLabel
@onready var unit_state_label: Label = %UnitStateLabel

var _tracked_unit: FriendlyUnit = null
var _tween: Tween = null

func _ready() ->void:
	visible = false
	SignalBus.on_unit_selected.connect(_on_unit_selected)
	SignalBus.on_unit_deselected.connect(_on_unit_deselected)
	SignalBus.on_unit_lost.connect(_on_unit_lost)

func _process(_delta: float) ->void:
	if not visible or not _tracked_unit:
		return
	# Poll unit state for live display
	var state := "IDLE"
	if _tracked_unit.is_gathering:
		state = "GATHERING"
	elif _tracked_unit.is_moving:
		state = "MOVING"
	unit_state_label.text = state

func _on_unit_selected(unit: FriendlyUnit) ->void:
	_tracked_unit = unit
	unit_type_label.text = "KAKAPO  •  " + ("DAY" if unit.type == FriendlyUnit.UnitType.DAY else "NIGHT")
	unit_state_label.text = "IDLE"
	_show()

func _on_unit_deselected(_unit: FriendlyUnit) ->void:
	_tracked_unit = null
	_hide()

func _on_unit_lost(unit: FriendlyUnit) ->void:
	if unit == _tracked_unit:
		_tracked_unit = null
		_hide()

func _show() ->void:
	visible = true
	if _tween:
		_tween.kill()
	modulate.a = 0.0
	_tween = create_tween()
	_tween.tween_property(self , "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT)

func _hide() ->void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self , "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN)
	await _tween.finished
	visible = false

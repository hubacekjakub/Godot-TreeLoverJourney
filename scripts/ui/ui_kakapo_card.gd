extends MarginContainer

@onready var name_label: Label = %NameLabel
@onready var action_label: Label = %ActionLabel

var unit: FriendlyUnit = null
var _is_active: bool = false
var _is_lost: bool = false
var _tween: Tween = null

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_theme_constant_override("margin_top", 20)
	modulate = Color(0.9, 0.9, 0.9, 1)

func setup(target_unit: FriendlyUnit) -> void:
	unit = target_unit
	if unit:
		name_label.text = unit.custom_name

func _process(_delta: float) -> void:
	if not unit or _is_lost:
		return

	if unit.is_lost:
		set_lost()
		return

	var state := "IDLE"
	if unit.is_moving:
		state = "MOVING"
	elif unit.is_gathering:
		state = "GATHERING"

	if action_label.text != state:
		action_label.text = state

func set_active(active: bool) -> void:
	if _is_lost:
		return
	if _is_active == active:
		return

	_is_active = active

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)

	if _is_active:
		_tween.tween_method(_set_margin_top, get_theme_constant("margin_top"), 0, 0.2).set_ease(Tween.EASE_OUT)
		_tween.tween_property(self , "modulate", Color(1, 1, 1, 1), 0.2)
	else:
		_tween.tween_method(_set_margin_top, get_theme_constant("margin_top"), 20, 0.2).set_ease(Tween.EASE_OUT)
		_tween.tween_property(self , "modulate", Color(0.9, 0.9, 0.9, 1), 0.2)

func set_lost() -> void:
	if _is_lost:
		return
	_is_lost = true
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_method(_set_margin_top, get_theme_constant("margin_top"), 30, 0.3).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self , "modulate", Color(0.5, 0.5, 0.5, 0.5), 0.3)
	action_label.text = "LOST"

func _set_margin_top(value: int) -> void:
	add_theme_constant_override("margin_top", value)

func _on_gui_input(event: InputEvent) -> void:
	if _is_lost or not unit:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if _is_active:
			SignalBus.on_unit_deselected.emit(unit)
		else:
			SignalBus.on_unit_selected.emit(unit)

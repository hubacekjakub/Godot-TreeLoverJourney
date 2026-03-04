extends CanvasLayer
## Central HUD controller. Coordinates panel visibility and phase transitions.

@onready var resources_panel: Control = %ResourcesPanel
@onready var night_timer: Control = %NightTimer
@onready var phase_label: Label = %PhaseLabel
@onready var level_label: Label = %LevelLabel

var _phase_tween: Tween = null

func _ready() -> void:
	SignalBus.on_day_start.connect(_on_day_start)
	SignalBus.on_night_transition_start.connect(_on_night_transition_start)
	SignalBus.on_night_start.connect(_on_night_start)
	SignalBus.on_night_end.connect(_on_night_end)

	# Initial state
	_set_phase_label("DAY")
	_update_level_label(Global.current_level_index)


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

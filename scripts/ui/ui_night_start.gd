extends MarginContainer
class_name NightStart

@onready var start_night: Button = %StartNight

var _tween: Tween = null

func _ready() -> void:
	visible = false
	SignalBus.on_night_transition_finished.connect(handle_night_transition_finished)
	start_night.button_down.connect(handle_night_start_button_down)

func handle_night_transition_finished() -> void:
	await get_tree().create_timer(1.0).timeout

	visible = true

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(self, "position:y", position.y, 0.4).from(-size.y).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "modulate:a", 1.0, 0.3).from(0.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func handle_night_start_button_down() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await _tween.finished
	visible = false
	Global.start_night()

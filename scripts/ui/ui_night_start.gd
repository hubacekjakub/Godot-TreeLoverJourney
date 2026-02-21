extends MarginContainer
class_name NightStart

var slide_in_tween: Tween = null

@onready var start_night: Button = %StartNight

func _ready() -> void:
	SignalBus.on_night_transition_finished.connect(handle_night_transition_finished)
	start_night.button_down.connect(handle_night_start_button_down)

func handle_night_transition_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	self.visible = true
	slide_in_tween = get_tree().create_tween()
	slide_in_tween.tween_property(self, "position", Vector2(492.5,246.5), 0.5).set_ease(Tween.EASE_OUT_IN)

func handle_night_start_button_down() -> void:
	self.visible = false
	await get_tree().create_timer(1).timeout
	SignalBus.on_night_start.emit(NightDirector.current_night_level)

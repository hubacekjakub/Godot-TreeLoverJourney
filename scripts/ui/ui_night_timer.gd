extends MarginContainer
class_name NightTimer

var night_timer_tween: Tween = null

@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)

func handle_night_start(_level: int) -> void:
	self.visible = true

	if night_timer_tween:
		night_timer_tween.kill()
	progress_bar.value = 0
	var night_duration := NightDirector.get_night_duration()
	night_timer_tween = get_tree().create_tween()
	night_timer_tween.tween_method(_update_bar, 0.0, 100.0, night_duration).set_ease(Tween.EASE_IN_OUT)
	night_timer_tween.tween_callback(self.night_timer_finished)

func _update_bar(value: float) -> void:
	progress_bar.value = value

func night_timer_finished() -> void:
	NightDirector.night_timer_finished()

func handle_night_end(_is_success: bool) -> void:
	self.visible = false
	if night_timer_tween:
		night_timer_tween.kill()
		night_timer_tween = null

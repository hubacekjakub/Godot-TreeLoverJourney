extends MarginContainer
class_name LevelResult

var slide_in_tween: Tween = null
var is_success: bool = true

@onready var next_level: Button = %NextLevel
@onready var status_label: Label = %Status
@onready var title_label: Label = %TitleLabel

func _ready() -> void:
	SignalBus.on_night_end.connect(handle_night_end)
	next_level.button_down.connect(_on_button_button_down)

func handle_night_end(success: bool) -> void:
	is_success = success
	if is_success:
		title_label.text = "LEVEL COMPLETE"
		status_label.text = "You survived the night!"
		next_level.text = "NEXT LEVEL"
	else:
		title_label.text = "LEVEL FAILED"
		status_label.text = "All supplies were stolen!"
		next_level.text = "RETRY"

	self.visible = true
	slide_in_tween = get_tree().create_tween()
	slide_in_tween.tween_property(self, "position", Vector2(506.5,246.5), 0.5).set_ease(Tween.EASE_OUT_IN)

func _on_button_button_down() -> void:
	SoundManager.play_button_sound_effect()
	if is_success:
		Global.go_to_next_level()
	else:
		SceneChanger.restart_current_scene()

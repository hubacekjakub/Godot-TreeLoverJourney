extends MarginContainer
class_name LevelResult

var slide_in_tween: Tween = null

@onready var next_level: Button = %NextLevel

func _ready() -> void:
	SignalBus.on_night_end.connect(handle_night_end)
	next_level.button_down.connect(_on_button_button_down)

func handle_night_end(_is_success: bool) -> void:
	self.visible = true
	slide_in_tween = get_tree().create_tween()
	slide_in_tween.tween_property(self, "position", Vector2(506.5,246.5), 2.0).set_ease(Tween.EASE_OUT_IN)

func _on_button_button_down() -> void:
	Global.next_level()
	print("LevelResult: Lets go to another screen")
	pass # Replace with function body.

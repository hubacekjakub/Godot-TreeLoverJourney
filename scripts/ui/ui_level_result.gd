extends MarginContainer
class_name LevelResult

var slide_in_tween: Tween = null

func _ready() -> void:
	SignalBus.on_night_end.connect(handle_night_end)

func handle_night_end(_is_success: bool) -> void:
	self.visible = true
	slide_in_tween = get_tree().create_tween()
	slide_in_tween.tween_property(self, "position", Vector2(533.0, 228.0), 1.0)

func _on_button_button_down() -> void:
	print("LevelResult: Lets go to another screen")
	pass # Replace with function body.

extends MarginContainer
class_name Tutorial

signal dismissed

@onready var got_it_button: Button = %GotItButton

func _ready() -> void:
	got_it_button.pressed.connect(handle_got_it_pressed)

func handle_got_it_pressed() -> void:
	self.visible = false
	dismissed.emit()

extends Control

@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	SoundManager.play_button_sound_effect()
	await get_tree().create_timer(0.3).timeout
	SceneChanger.goto_main_menu()

extends Node3D

# Exports
@export var start_level: String = "uid://y6osr473v6x0"
@export var credits_scene: String = "uid://4fw3sv5l0qtw"

# UI elements
@onready var version_label: Label = %VersionLabel
@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	version_label.text = "Version: " + Global.get_game_version()

	start_button.pressed.connect(_on_start_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)

	if OS.has_feature("web"):
		quit_button.hide()
	else:
		quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	SoundManager.play_button_sound_effect()
	await get_tree().create_timer(0.3).timeout
	SceneChanger.goto_scene(start_level)

func _on_credits_button_pressed() -> void:
	SoundManager.play_button_sound_effect()
	await get_tree().create_timer(0.3).timeout
	SceneChanger.goto_scene(credits_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

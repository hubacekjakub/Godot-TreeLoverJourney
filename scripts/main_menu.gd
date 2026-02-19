extends Node3D

# Exports
@export var start_level : String = "uid://y6osr473v6x0"

# UI elements
@onready var version_label: Label = %VersionLabel
@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version_label.text = "Version: " + Global.get_game_version()

	start_button.pressed.connect(_on_start_button_pressed)

	if OS.has_feature("web"):
		quit_button.hide()
	else:
		quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	SceneChanger.goto_scene(start_level)


func _on_quit_button_pressed():
	get_tree().quit()

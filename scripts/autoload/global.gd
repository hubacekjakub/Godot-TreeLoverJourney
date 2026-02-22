extends Node

@export var next_level: String = "uid://bvsa3uvjw3yet"

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func go_to_next_level() -> void:
	SceneChanger.goto_scene(next_level)

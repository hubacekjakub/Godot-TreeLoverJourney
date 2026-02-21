extends Node

@export var next_level: String = "uid://cy8unddt2maqp"

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func go_to_next_level() -> void:
	SceneChanger.goto_scene(next_level)

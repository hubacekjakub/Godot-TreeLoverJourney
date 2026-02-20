extends Node

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func next_level() -> void:
	SceneChanger.goto_scene("res://levels/main_level.tscn")

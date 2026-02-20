extends Node

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

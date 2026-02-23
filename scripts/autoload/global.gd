extends Node

enum GameState {
	PRE_DAY,
	DAY,
	TRANSITION_TO_NIGHT,
	NIGHT
}
var current_state: GameState = GameState.PRE_DAY

@export var next_level: String = "uid://bvsa3uvjw3yet"

func _ready() -> void:
	SignalBus.on_day_end.connect(handle_day_end)
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func go_to_next_level() -> void:
	SceneChanger.goto_scene(next_level)

func go_to_end_cutscene() -> void:
	SceneChanger.goto_scene("uid://blx447c52b2ay")

func start_day() -> void:
	if current_state == GameState.PRE_DAY or current_state == GameState.NIGHT:
		current_state = GameState.DAY
		SignalBus.on_day_start.emit()

func handle_day_end() -> void:
	current_state = GameState.TRANSITION_TO_NIGHT
	SignalBus.on_night_transition_start.emit()

func handle_night_start(_level: int) -> void:
	current_state = GameState.NIGHT

func handle_night_end(_success: bool) -> void:
	current_state = GameState.PRE_DAY

extends Node

enum GameState {
	PRE_DAY,
	DAY,
	TRANSITION_TO_NIGHT,
	NIGHT
}
var current_state: GameState = GameState.PRE_DAY

@export var level_list: LevelList
var current_level_index: int = 0

func _ready() -> void:
	SignalBus.on_day_end.connect(handle_day_end)
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)
	SignalBus.map_loaded.connect(_handle_map_loaded)

func get_game_version() -> Variant:
	return ProjectSettings.get_setting("application/config/version")

func go_to_next_level() -> void:
	current_level_index += 1
	if level_list and current_level_index < level_list.levels.size():
		SceneChanger.goto_scene(level_list.levels[current_level_index].resource_path)
	else:
		go_to_end_cutscene()

func go_to_end_cutscene() -> void:
	if level_list and level_list.outro_cutscene:
		SceneChanger.goto_scene(level_list.outro_cutscene.resource_path)

func go_to_intro_cutscene() -> void:
	if level_list and level_list.intro_cutscene:
		SceneChanger.goto_scene(level_list.intro_cutscene.resource_path)

func go_to_first_level() -> void:
	current_level_index = 0
	if level_list and level_list.levels.size() > 0:
		SceneChanger.goto_scene(level_list.levels[0].resource_path)

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

func go_to_main_menu() -> void:
	SceneChanger.goto_main_menu()

func _handle_map_loaded(_map_path: String) -> void:
	Supplies.reset()

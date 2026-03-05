extends Node3D
class_name Level

@export var config: LevelConfig
@export var stretcher: Stretcher
@export var level_camera: Camera3D
@export var show_tutorial: bool = false

@onready var tutorial_ui: Tutorial = $HUD/Tutorial


var camera_tween: Tween = null

func _get_begin_wait_time() -> float:
	return config.begin_wait_time if config else 3.5

func _ready() -> void:
	if config:
		NightDirector.set_config(config)
	SignalBus.on_night_transition_start.connect(start_night_transition)

	await get_tree().create_timer(_get_begin_wait_time()).timeout
	if show_tutorial:
		tutorial_ui.dismissed.connect(handle_tutorial_dismissed)
		tutorial_ui.visible = true
	else:
		Global.start_day()

# prepares level for night gameplay
func start_night_transition() -> void:
	var night_location_transform = level_camera.global_transform
	level_camera.transform = stretcher.get_camera_transform()
	level_camera.current = true

	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(level_camera, "transform", night_location_transform, 1.5).set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_callback(self.night_camera_move_finished)

func night_camera_move_finished() -> void:
	SignalBus.on_night_transition_finished.emit()

func handle_tutorial_dismissed() -> void:
	await get_tree().create_timer(_get_begin_wait_time()).timeout
	Global.start_day()

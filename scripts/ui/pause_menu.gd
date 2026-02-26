extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton
@onready var panel_container: MarginContainer = $PanelContainer
@onready var overlay: ColorRect = $Overlay

var _tween: Tween = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	resume_button.pressed.connect(_on_resume)
	restart_button.pressed.connect(_on_restart)
	main_menu_button.pressed.connect(_on_main_menu)

	if OS.has_feature("web"):
		quit_button.hide()
	else:
		quit_button.pressed.connect(_on_quit)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		get_viewport().set_input_as_handled()

func _toggle_pause() -> void:
	if visible:
		_unpause()
	else:
		_pause()

func _pause() -> void:
	get_tree().paused = true
	visible = true

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(panel_container, "position:y", panel_container.position.y, 0.35).from(-panel_container.size.y).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(panel_container, "modulate:a", 1.0, 0.25).from(0.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(overlay, "modulate:a", 1.0, 0.25).from(0.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _unpause() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(panel_container, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_tween.tween_property(overlay, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await _tween.finished
	visible = false
	get_tree().paused = false

func _on_resume() -> void:
	SoundManager.play_button_sound_effect()
	_unpause()

func _on_restart() -> void:
	SoundManager.play_button_sound_effect()
	_unpause()
	SceneChanger.restart_current_scene()

func _on_main_menu() -> void:
	SoundManager.play_button_sound_effect()
	_unpause()
	SceneChanger.goto_main_menu()

func _on_quit() -> void:
	get_tree().quit()

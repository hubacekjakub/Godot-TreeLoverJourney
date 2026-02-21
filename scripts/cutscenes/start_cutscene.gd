extends Node3D

@export var next_level: String = "uid://cy8unddt2maqp"
@export var startup_wait: float = 3

@onready var rich_text_label: RichTextLabel = $UI/Panel/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_parrot: AnimationPlayer = $AnimationPlayerParrot
@onready var panel: Panel = $UI/Panel
@onready var timer: Timer = $Timer

var text_lines: Array[String]
var line_index: int = 0
var is_done: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible = false
	timer.timeout.connect(handle_timeout)
	animation_player.animation_finished.connect(handle_animation_finished)
	animation_player_parrot.animation_finished.connect(handle_animation_parrot_finished)
	rich_text_label.visible_ratio = 0
	init_text_lines()
	animation_player.play("camera_move")
	animation_player_parrot.play("walking")


func handle_animation_finished(anim_name: StringName) -> void:
	if anim_name == "camera_move":
		next_line()
	if anim_name == "writing" and not is_done:
		timer.start()

func handle_animation_parrot_finished(anim_name: StringName) -> void:
	if anim_name == "walking":
		animation_player_parrot.play("climbing")

func init_text_lines() -> void:
	text_lines.append("[center]There was a brave parrot Kakapo.[/center]")
	text_lines.append("[center]This Kakapo was tired, because everyone thinks, that these parrots are the most useless animals on the earth.[/center]")
	text_lines.append("[center]Kakapo thinks, when I climb this tree, then everybody sees, I'm not useless, we are not useless![/center]")
	text_lines.append("[center]So he start climbing... and climbing...[/center]")
	text_lines.append("[center][center]Of course he felt and this is beggining of our story... our JOURNEY.[/center][/center]")

func handle_timeout() -> void:
	rich_text_label.text = ""
	next_line()

func next_line() -> void:
	if line_index < text_lines.size():
		panel.visible = true
		rich_text_label.text = text_lines[line_index]
		line_index += 1
		animation_player.play("writing")
	else:
		is_done = true
		panel.visible = false
		SceneChanger.goto_scene(next_level)

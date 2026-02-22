extends Node3D

@export var next_level: String = "uid://day083c7paac0"
@export var startup_wait: float = 2

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
	animation_player_parrot.animation_finished.connect(handle_animation_finished)
	rich_text_label.visible_ratio = 0
	init_text_lines()
	await get_tree().create_timer(startup_wait).timeout
	animation_player.play("camera_move")



func handle_animation_finished(anim_name: StringName) -> void:
	if anim_name == "camera_move" and not is_done:
		next_line()
	if anim_name == "writing" and not is_done:
		timer.start()

func handle_animation_movement_finished(anim_name: StringName) -> void:
	if anim_name == "climbing":
		animation_player_parrot.play("Parrot/parrot_idle")

	if anim_name == "walking":
		animation_player_parrot.play("Parrot/parrot_idle")


func init_text_lines() -> void:
	text_lines.append("[center]The parrots made it against all odds through the forest.[/center]")
	text_lines.append("[center]As they approached the shaman's hut the old wise parrot was idling in front of his hut.[/center]")
	text_lines.append("[center]The shaman took a look at Brian, turned around and entered his hut without a word.[/center]")
	text_lines.append("[center]He returned after a while with bandages and an ointment. He smeared the wounds with the ointment and dressed them up with the bandages. After that he returned to his hut, again without a word.[/center]")
	text_lines.append("[center]Brian would heal in a few days. But how long will it take before he does some other dumb thing again?[/center]")
	text_lines.append("[center]Who knows...[/center]")


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

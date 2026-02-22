extends Node3D

@export var next_level: String = "uid://cy8unddt2maqp"
@export var startup_wait: float = 2

@onready var rich_text_label: RichTextLabel = $UI/Panel/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_parrot: AnimationPlayer = $AnimationPlayerParrot
@onready var animation_player_movement: AnimationPlayer = $AnimationPlayerMovement
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
	animation_player_movement.animation_finished.connect(handle_animation_movement_finished)
	rich_text_label.visible_ratio = 0
	init_text_lines()
	await get_tree().create_timer(startup_wait).timeout
	next_line()
	# animation_player.play("camera_move")
	# animation_player_parrot.play("walking")


func handle_animation_finished(anim_name: StringName) -> void:
	if anim_name == "writing" and not is_done:
		timer.start()

	if line_index == 1:
		animation_player_parrot.play("Parrot/parrot_run")
		animation_player_movement.play("walking")
		animation_player.play("camera_move")

	if line_index == 4:
		animation_player_parrot.play("Parrot/parrot_gather")
		animation_player_movement.play("climbing")

	if line_index == 5:
		animation_player_parrot.play("Parrot/parrot_gather")
		animation_player_movement.play("falling")

func handle_animation_movement_finished(anim_name: StringName) -> void:
	if anim_name == "climbing":
		animation_player_parrot.play("Parrot/parrot_idle")

	if anim_name == "walking":
		animation_player_parrot.play("Parrot/parrot_idle")


func init_text_lines() -> void:
	text_lines.append("[center]It was a calm day in the forest. It seemed that nothing interesting is going to happen.[/center]")
	text_lines.append("[center]But then there was Brian. The embodiment of all prejudice towards kakapo parrots.[/center]")
	text_lines.append("[center]To put it simply Brain was an idiot.[/center]")
	text_lines.append("[center]And it was on this calm day, that Brian decided to climb on a tree. And to his own surprise he succeeded.[/center]")
	text_lines.append("[center]The problem came when he wanted to get back down and realized he cannot fly. So he just jumped.[/center]")
	text_lines.append("[center]The tree was fairly high and Brian broke both his legs and one of his wings.[/center]")
	text_lines.append("[center]Luckily, two members of his tribe were collecting berries nearby and helped Brian back to the village.[/center]")
	text_lines.append("[center]His wounds were too serious though and could only be treated by a shaman hermit living far in the woods.[/center]")
	text_lines.append("[center]The most capable members of the tribe created a stretcher for Brian and set out for the journey to bring Brian to the shaman…[/center]")


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

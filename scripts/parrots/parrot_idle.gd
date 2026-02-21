extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	run_idle_animation()


func run_idle_animation():
	animation_player.play("Parrot/parrot_idle")


extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	run_idle_animation()

func run_idle_animation() -> void:
	animation_player.play("Parrot/parrot_idle")

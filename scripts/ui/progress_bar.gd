extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

var parent: Node3D

func _ready() -> void:
	parent = get_parent()
	if (parent == null):
		push_error("Node %s: 3D to 2D failed! Parent is not a Node3D" % [name])

func _process(_delta: float) -> void:
	position = get_viewport().get_camera_3d().unproject_position(parent.global_position) + Vector2(size.x/2, 0)

func set_progress(value: float) -> void:
	progress_bar.value = value

func get_progress() -> float:
	return progress_bar.value

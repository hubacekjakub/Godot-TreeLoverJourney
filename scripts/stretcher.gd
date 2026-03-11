extends CharacterBody3D
class_name Stretcher

signal march_finished

# Max cruising speed in m/s along the path
@export var speed: float = 14
# Acceleration/deceleration rate in m/s²
@export var acceleration: float = 5.0
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: float = 50

@export var on_path: bool = false

@onready var camera_target: Marker3D = $CameraTargetMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_parrot: AnimationPlayer = $AnimationPlayerParrot
@onready var navigation_obstacle: NavigationObstacle3D = $NavigationObstacle3D

var target_velocity: Vector3 = Vector3.ZERO
var visibility_distance: float = 15.0
var last_position: Vector3 = Vector3.ZERO

var path_follow: PathFollow3D = null
var current_speed: float = 0.0
var marching: bool = false

func _enter_tree() -> void:
	DayDirector.register_stretcher(self )

func _ready() -> void:
	if on_path:
		path_follow = get_parent() as PathFollow3D

func start_march() -> void:
	if on_path and path_follow:
		marching = true
		current_speed = 0.0
		animation_player.play("wheel_anim")
		animation_player_parrot.play("root|pull")

func stop_march() -> void:
	marching = false
	current_speed = 0.0
	animation_player.stop()
	animation_player_parrot.stop()

func _physics_process(delta: float) -> void:
	var current_position := global_position

	if on_path:
		if marching:
			var parent_path := path_follow.get_parent() as Path3D
			var curve_length: float = parent_path.curve.get_baked_length() if parent_path and parent_path.curve else 0.0
			var remaining: float = curve_length - path_follow.progress
			# Distance needed to decelerate from current_speed to 0: v²/(2a)
			var stopping_distance := (current_speed * current_speed) / (2.0 * acceleration)

			if remaining <= stopping_distance:
				# Decelerate
				current_speed = maxf(current_speed - acceleration * delta, 0.0)
			else:
				# Accelerate toward max speed
				current_speed = minf(current_speed + acceleration * delta, speed)

			path_follow.progress += current_speed * delta

			if path_follow.progress_ratio >= 1.0:
				stop_march()
				march_finished.emit()

		velocity = (current_position - last_position) / delta
	else:
		if not is_on_floor():
			target_velocity.y -= fall_acceleration * delta
		else:
			target_velocity.y = 0.0
		velocity = target_velocity
		move_and_slide()

	if navigation_obstacle:
		navigation_obstacle.velocity = velocity
	last_position = current_position

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Resource"):
		if area is Supply:
			area.activate()


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Resource"):
		if area is Supply:
			area.deactivate()

func get_camera_transform() -> Transform3D:
	return camera_target.global_transform

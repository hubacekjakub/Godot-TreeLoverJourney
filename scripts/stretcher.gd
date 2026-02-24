extends CharacterBody3D
class_name Stretcher

# How fast the player moves in meters per second.
@export var speed: float = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration: float = 50

@onready var camera: Camera3D = $Camera
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_parrot: AnimationPlayer = $AnimationPlayerParrot

var target_velocity: Vector3 = Vector3.ZERO

var distance_check: float = 30.0
var visibility_distance: float = 15.0

var automove: bool = false
var current_target: RestingPlace

func _enter_tree() -> void:
	UnitDirector.register_stretcher(self)

func _ready() -> void:
	SignalBus.new_resting_place_set.connect(handle_new_resting_place_set)

func _physics_process(delta):
	var direction = Vector3.ZERO

	if automove:
		var direction_to_target = self.global_position.direction_to(current_target.global_position)
		direction = direction_to_target

		var distance_to_target = self.global_position.distance_squared_to(current_target.global_position)
		animation_player.play("wheel_anim")
		animation_player_parrot.play("root|pull")
		if (distance_to_target < distance_check):
			SignalBus.resting_place_reached.emit()
			automove = false
			animation_player.stop()
			animation_player_parrot.stop()


	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func handle_new_resting_place_set(new_resting_place: RestingPlace):
	current_target = new_resting_place
	automove = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Resource"):
		if area is Supply:
			area.activate()


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Resource"):
		if area is Supply:
			area.deactivate()

func get_camera_transform() -> Transform3D:
	return camera.global_transform

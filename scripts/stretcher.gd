extends CharacterBody3D
class_name Stretcher

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 50

@onready var camera: Camera3D = $Camera

var target_velocity = Vector3.ZERO

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

	#if Input.is_action_pressed("move_right"):
	#	direction.z += 1
	#if Input.is_action_pressed("move_left"):
	#	direction.z -= 1
	#if Input.is_action_pressed("move_back"):
	#	direction.x -= 1
	#if Input.is_action_pressed("move_forward"):
	#	direction.x += 1

	if automove:
		var direction_to_target = self.global_position.direction_to(current_target.global_position)
		direction = direction_to_target

		var distance_to_target = self.global_position.distance_squared_to(current_target.global_position)
		#print(distance_to_target)
		if(distance_to_target < distance_check):
			SignalBus.resting_place_reached.emit()
			automove = false

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		#$Nositka.basis = Basis.looking_at(direction)

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
			#print("found supply of value: ", area.value)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Resource"):
		if area is Supply:
			area.deactivate()

func get_camera_transform() -> Transform3D:
	return camera.global_transform

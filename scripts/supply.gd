extends Area3D
class_name Supply

enum SupplyType {BERRY = 0, WOOD = 1}

@export_range(0, 100, 5) var amount: int = 10
@export var type: SupplyType = SupplyType.BERRY

@export_group("Visual Setup")
@export var color_active: Color = Color("b85306")
@export var color_inactive: Color = Color("5b2903")

@export_group("Timers")
## How long it takes one unit to collect the resource
@export_range(0, 10) var collection_time: float = 4.0
## How fast after collecting is interrupted will the timer reset
@export_range(0, 5) var interrupt_time: float = 1.0

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collecting_timer: Timer = $CollectingTimer
@onready var progress_bar: Control = $ProgressBar

var material: StandardMaterial3D
var active: bool = false

var progress_tween: Tween = null

func _ready() -> void:
	material = csg_cylinder_3d.material.duplicate()
	csg_cylinder_3d.material_override = material
	progress_bar.visible = false

func activate() -> void:
	active = true
	material.albedo_color = color_active

func deactivate() -> void:
	active = false
	material.albedo_color = color_inactive

func start_collecting() -> void:
	if progress_tween:
		progress_tween.kill()
		progress_tween = null

	if progress_tween == null:
		progress_bar.visible = true
		progress_tween = get_tree().create_tween()
		var current_progress: float = progress_bar.get_progress()
		progress_tween.tween_method(progress_bar.set_progress, current_progress, 100, collection_time)
		progress_tween.tween_callback(self.collecting_finished)

func stop_collecting() -> void:
	if progress_tween:
		progress_tween.kill()
		progress_tween = get_tree().create_tween()
		var current_progress: float = progress_bar.get_progress()
		progress_tween.tween_method(progress_bar.set_progress, current_progress, 0, interrupt_time)
		progress_tween.tween_callback(self.collecting_interrupted)

func collecting_finished() -> void:
	Supplies.supply_collected(self, amount)
	collision_shape_3d.disabled = true
	await get_tree().create_timer(0.1).timeout
	queue_free()

func enemy_picked() -> void:
	Supplies.supply_stolen(self, amount)
	collision_shape_3d.disabled = true
	await get_tree().create_timer(0.1).timeout
	queue_free()

func collecting_interrupted() -> void:
	progress_bar.visible = false

func _on_body_entered(body: Node3D) -> void:
	if NightDirector.is_night_active:
		return

	if body is FriendlyUnit:
		start_collecting()
		body.is_gathering = true

func _on_body_exited(body: Node3D) -> void:
	if body is FriendlyUnit:
		stop_collecting()
		body.is_gathering = false

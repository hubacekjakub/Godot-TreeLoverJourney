extends Area3D
class_name Supply

enum ResoruceType {BERRY = 0, WOOD = 1}

@export_range(0, 100, 5) var amount: int = 10
@export var type: ResoruceType = ResoruceType.BERRY

@export_group("Visual Setup")
@export var color_active : Color = Color("b85306")
@export var color_unactive : Color = Color("5b2903")

@export_group("Timers")
## How long it takes one unit to collect the resource
@export_range(0, 10) var collection_time: float = 4.0
## How fast after collecting is interupted will the timer reset
@export_range(0, 5) var interrupt_time: float = 1.0

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var collecting_timer: Timer = $CollectingTimer
#@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var progress_bar: Control = $ProgressBar

var material: StandardMaterial3D
var active: bool = false

var progress_tween: Tween = null

func _ready() -> void:
	material = csg_cylinder_3d.material.duplicate()
	csg_cylinder_3d.material_override = material
	progress_bar.visible = false

func activate():
	active = true
	material.albedo_color = color_active

func deactivate():
	active = false
	material.albedo_color = color_unactive

func start_collecting():
	print("Supply: resource picking started")

	if progress_tween:
		progress_tween.kill()
		progress_tween = null

	if progress_tween == null:
		progress_bar.visible = true
		progress_tween = get_tree().create_tween()
		var current_progress : float = progress_bar.get_progress()
		progress_tween.tween_method(progress_bar.set_progress, current_progress, 100, collection_time)
		progress_tween.tween_callback(self.collecting_finished)

	#await get_tree().create_timer(collection_time).timeout
	#queue_free()

func stop_collecting():
	print("Supply: Supply picking interrupted")
	if progress_tween:
		progress_tween.kill()
		progress_tween = create_tween()
		var current_progress : float = progress_bar.get_progress()
		progress_tween.tween_method(progress_bar.set_progress, current_progress, 0, interrupt_time)
		progress_tween.tween_callback(self.collecting_interupted)

func collecting_finished() -> void:
	print("Supply: resource picking finished")
	Supplies.supply_collected(self, amount)
	SignalBus.on_supply_collected.emit(self, amount)
	await get_tree().create_timer(0.1).timeout
	collision_shape_3d.disabled = true
	queue_free()

func enemy_picked() -> void:
	print("Supply: enemy stole a resource")
	Supplies.supply_stolen(self, amount)
	SignalBus.on_supply_stolen.emit(self, amount)
	await get_tree().create_timer(0.1).timeout
	queue_free()

func collecting_interupted() -> void:
	progress_bar.visible = false

func _on_body_entered(body: Node3D) -> void:
	if NightDirector.is_night_active:
		return

	print("body entered: ", body)
	if body is FriendlyUnit:
		start_collecting()
		body.is_gathering = true

func _on_body_exited(body: Node3D) -> void:
	print("body exited: ",body)
	if body is FriendlyUnit:
		stop_collecting()
		body.is_gathering = false

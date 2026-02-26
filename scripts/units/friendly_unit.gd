extends BaseUnit
class_name FriendlyUnit


enum UnitType {
	DAY,
	NIGHT
}

@export var type: UnitType = UnitType.DAY

@export var color_active: Color = Color("00abd1")
@export var color_inactive: Color = Color("005acb")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selection_marker: Node3D = $SelectionMarker

var material: StandardMaterial3D
var is_active: bool = false
var is_lost: bool = false

func _enter_tree() -> void:
	UnitDirector.register_unit(self)


func _ready() -> void:
	super._ready()
	selection_marker.visible = false
	play_idle_animation()


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_enabled:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SignalBus.on_unit_selected.emit(self)


func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)

	if is_gathering:
		play_gather_animation()
	elif is_moving:
		play_run_animation()
	else:
		play_idle_animation()


func activate() -> void:
	is_active = true
	selection_marker.visible = true


func deactivate() -> void:
	is_active = false
	selection_marker.visible = false
	animation_player.stop()

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	pass


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	is_lost = true
	set_physics_process(false)
	UnitDirector.register_lost_unit(self)


func play_idle_animation() -> void:
	animation_player.play("Parrot/parrot_idle")

func play_run_animation() -> void:
	animation_player.play("Parrot/parrot_run")

func play_gather_animation() -> void:
	animation_player.play("Parrot/parrot_gather")

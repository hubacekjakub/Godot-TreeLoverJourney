extends BaseUnit
class_name EnemyUnit

var is_escaping: bool = false
var escape_target: Vector3 = Vector3.ZERO

var base: EnemyBase = null
var supply_target: Supply = null

func _ready() -> void:
	super._ready()
	SignalBus.on_supply_stolen.connect(handle_supply_stolen)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Friend"):
		activate_escape_mode()
		print("EnemyUnit: Found friend, activating escape mode")
	if area.is_in_group("Resource") and area is Supply:
		area.enemy_picked()
		activate_escape_mode()
		print("EnemyUnit: picked up supply")

func set_base(new_base: EnemyBase) -> void:
	self.base = new_base

func set_supply_target(supply: Supply) -> void:
	assert(supply != null, "Supply target is null!")
	supply_target = supply
	set_movement_target(supply.global_position)

func activate_escape_mode() -> void:
	is_escaping = true
	set_movement_target(base.global_position)

func handle_supply_stolen(resource: Supply, _amount: int) -> void:
	if resource == supply_target:
		activate_escape_mode()

func kill() -> void:
	queue_free()

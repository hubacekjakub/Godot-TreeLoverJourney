extends Area3D
class_name EnemyBase

@export var enemy_unit_scene: PackedScene = preload("uid://drd05xwqas67k")
@export var is_sending_units: bool = false
@export var supply_targets: Array[Supply] = []

func _ready() -> void:
	NightDirector.register_enemy_base(self)
	SignalBus.on_supply_stolen.connect(handle_supply_stolen)

# TODO: add collected_supply and use it instead of central location
# Send unit to central location of the unit director
func send_enemy_unit()-> void:
	if supply_targets.size() == 0:
		return

	print("Spawning enemy unit")
	var random_supply: Supply = get_random_supply_target()
	var new_enemy_unit = enemy_unit_scene.instantiate() as EnemyUnit

	if new_enemy_unit:
		add_child(new_enemy_unit)
		new_enemy_unit.set_base(self)
		new_enemy_unit.set_supply_target(random_supply)

func _on_body_entered(body: Node3D) -> void:
	if body is EnemyUnit and body.is_escaping:
		SignalBus.on_enemy_purged.emit(body)
		body.kill()

func get_random_supply_target() -> Supply:
	assert(supply_targets.size() > 0, "Supply targets array is empty!")
	var random_index = randi() % supply_targets.size()

	if supply_targets[random_index] == null:
		print("Warning: Supply target at index ", random_index, " is null!")
		return null
	else:
		return supply_targets[random_index]

func handle_supply_stolen(resource: Supply, _amount: int) -> void:
	if resource in supply_targets:
		supply_targets.erase(resource)

extends Area3D
class_name EnemyBase

@export var enemy_unit_scene: PackedScene = preload("uid://drd05xwqas67k")
@export var is_sending_units: bool = false

func _ready() -> void:
	NightDirector.register_enemy_base(self)

# TODO: add collected_supply and use it instead of central location
# Send unit to central location of the unit director
func send_enemy_unit()-> void:
	print("Spawning enemy unit")
	var central_location: Vector3 = UnitDirector.get_ground_position()
	var new_enemy_unit = enemy_unit_scene.instantiate() as EnemyUnit

	if new_enemy_unit:
		add_child(new_enemy_unit)
		new_enemy_unit.set_escape_target(self.global_position)
		new_enemy_unit.set_movement_target(central_location)

func _on_body_entered(body: Node3D) -> void:
	if body is EnemyUnit and body.is_escaping:
		SignalBus.on_enemy_purged.emit(body)
		body.kill()

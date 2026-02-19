extends BaseUnit
class_name EnemyUnit

var is_escaping: bool = false
var escape_target: Vector3 = Vector3.ZERO


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Friend"):
		activate_escape_mode()

func set_escape_target(target: Vector3) -> void:
	escape_target = target

func activate_escape_mode() -> void:
	is_escaping = true
	set_movement_target(escape_target)

func kill() -> void:
	queue_free()

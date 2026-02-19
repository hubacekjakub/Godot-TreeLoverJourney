extends Node

var enemy_spawn_frequency: float = 2
var start_up_delay: float = 5.0

var enemy_bases: Array[EnemyBase] = []

var timer : Timer

func _ready() -> void:
	pass
	#timer = Timer.new()
	#add_child(timer)
	#start_timer()

func register_enemy_base(enemy_base: EnemyBase) -> void:
	enemy_bases.append(enemy_base)

func start_timer() -> void:
	await get_tree().create_timer(start_up_delay).timeout
	timer.start(enemy_spawn_frequency)
	timer.timeout.connect(activate_enemy_spawn)

func activate_enemy_spawn() -> void:
	if enemy_bases.size() == 0:
		pass

	var random_enemy_base_index: int = randi() % enemy_bases.size()
	var random_enemy_base: EnemyBase = enemy_bases[random_enemy_base_index ]
	random_enemy_base.send_enemy_unit()
	print("Enemy unit sent from base index: ", random_enemy_base_index)

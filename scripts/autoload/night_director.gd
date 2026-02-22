extends Node

var enemy_spawn_frequency: float = 2
var start_up_delay: float = 5.0

var enemy_bases: Array[EnemyBase] = []
var enemy_difficulty: Dictionary[int, int] = {
	1: 1,
	2: 2,
	3: 3,
	4: 4,
	5: 5
}

var night_duration: Dictionary[int, float] = {
	1: 20,
	2: 20,
	3: 25,
	4: 30,
	5: 35
}

var enemies_purged: int = 0
var current_night_level: int = 1
var is_night_active: bool = false

var timer : Timer

func _ready() -> void:
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)
	SignalBus.on_enemy_purged.connect(handle_enemy_purged)
	timer = Timer.new()
	timer.timeout.connect(activate_enemy_spawn)
	add_child(timer)

func night_timer_finished() -> void:
	SignalBus.on_night_end.emit(true)

# starts the night game play
func handle_night_start(level: int) -> void:
	is_night_active = true
	current_night_level = level
	start_timer()
	print("Night: Night started at level: ", level)

func handle_night_end(_is_success: bool) -> void:
	print("Night: Night ended with success: ", _is_success)
	is_night_active = false
	stop_timer()
	# cleanup
	enemy_bases.clear()
	enemies_purged = 0

func register_enemy_base(enemy_base: EnemyBase) -> void:
	enemy_bases.append(enemy_base)

func start_timer() -> void:
	await get_tree().create_timer(start_up_delay).timeout
	timer.start(enemy_spawn_frequency)

func stop_timer() -> void:
	timer.stop()

func activate_enemy_spawn() -> void:
	if enemy_bases.size() == 0:
		return

	var random_enemy_base_index: int = randi() % enemy_bases.size()
	var random_enemy_base: EnemyBase = enemy_bases[random_enemy_base_index ]
	random_enemy_base.send_enemy_unit()
	print("Night: Enemy unit sent from base index: ", random_enemy_base_index)

func handle_enemy_purged(_enemy_unit: EnemyUnit) -> void:
	enemies_purged += 1
	print("Night: Enemy purged. Total purged: ", enemies_purged)

func get_night_difficulty() -> int:
	#TODO: increase current_night_level
	return enemy_difficulty[current_night_level]
func get_night_duration() -> float:
	#TODO: increase current_night_level
	return night_duration[current_night_level]

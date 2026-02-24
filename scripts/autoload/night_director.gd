extends Node

var enemy_bases: Array[EnemyBase] = []
var enemies_purged: int = 0
var is_night_active: bool = false

var current_config: LevelConfig = null
var timer: Timer

func _ready() -> void:
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_night_end.connect(handle_night_end)
	SignalBus.on_enemy_purged.connect(handle_enemy_purged)
	timer = Timer.new()
	timer.timeout.connect(activate_enemy_spawn)
	add_child(timer)

func set_config(config: LevelConfig) -> void:
	current_config = config

func night_timer_finished() -> void:
	SignalBus.on_night_end.emit(true)

# starts the night game play
func handle_night_start(_level: int) -> void:
	is_night_active = true
	start_timer()

func handle_night_end(_is_success: bool) -> void:
	is_night_active = false
	stop_timer()
	# cleanup
	enemy_bases.clear()
	enemies_purged = 0

func register_enemy_base(enemy_base: EnemyBase) -> void:
	enemy_bases.append(enemy_base)

func start_timer() -> void:
	var delay := current_config.start_up_delay if current_config else 5.0
	var frequency := current_config.enemy_spawn_frequency if current_config else 2.0
	await get_tree().create_timer(delay).timeout
	timer.start(frequency)

func stop_timer() -> void:
	timer.stop()

func activate_enemy_spawn() -> void:
	if enemy_bases.size() == 0:
		return

	var random_enemy_base_index: int = randi() % enemy_bases.size()
	var random_enemy_base: EnemyBase = enemy_bases[random_enemy_base_index]
	random_enemy_base.send_enemy_unit()

func handle_enemy_purged(_enemy_unit: EnemyUnit) -> void:
	enemies_purged += 1

func get_night_difficulty() -> int:
	return current_config.enemy_difficulty if current_config else 1

func get_night_duration() -> float:
	return current_config.night_duration if current_config else 20.0

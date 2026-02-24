extends Resource
class_name LevelConfig

@export_category("Day")
## Delay in seconds before the day phase begins
@export var begin_wait_time: float = 3.5

@export_category("Night")
## How many enemies can be active at once
@export var enemy_difficulty: int = 1
## How long the night phase lasts in seconds
@export var night_duration: float = 20.0
## Seconds between enemy spawns
@export var enemy_spawn_frequency: float = 2.0
## Delay before first enemy spawns
@export var start_up_delay: float = 5.0

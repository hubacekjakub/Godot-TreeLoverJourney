extends Node


# Map events

# called when new map is loaded
@warning_ignore("unused_signal")
signal on_map_loaded(map_name: String)

# UnitDirector

# called when new unit is registered
@warning_ignore("unused_signal")
signal on_unit_registered(unit: FriendlyUnit)

# called when new unit is selected
@warning_ignore("unused_signal")
signal on_unit_selected(unit: FriendlyUnit)

# called when unit is deselected
@warning_ignore("unused_signal")
signal on_unit_deselected(unit: FriendlyUnit)

# called when unit is lost off the screen
@warning_ignore("unused_signal")
signal on_unit_lost(unit: FriendlyUnit)

# DayDirector

# called when day starts
@warning_ignore("unused_signal")
signal on_day_start()

# called when day ends
@warning_ignore("unused_signal")
signal on_day_end()

# NightDirector

# called when transition to night starts
@warning_ignore("unused_signal")
signal on_night_transition_start()

# called when transition to night ends
@warning_ignore("unused_signal")
signal on_night_transition_finished()

# called when night gameplay starts
@warning_ignore("unused_signal")
signal on_night_start(level: int)

# called when night gameplay ends
@warning_ignore("unused_signal")
signal on_night_end(success: bool)

# called when an enemy unit is purged
@warning_ignore("unused_signal")
signal on_enemy_purged(enemy_unit: EnemyUnit)

# called when the enemies purged count changes (for HUD display)
@warning_ignore("unused_signal")
signal on_enemy_kill_count_changed(count: int)

# Resources

# called when a supply is collected
@warning_ignore("unused_signal")
signal on_supply_collected(supply: Supply, amount: int)

# called when a supply is stolen
@warning_ignore("unused_signal")
signal on_supply_stolen(supply: Supply, amount: int)

# called when supplies are updated
@warning_ignore("unused_signal")
signal on_supply_updated()

# SceneChanger
@warning_ignore("unused_signal")
signal on_fade_out_finished()

@warning_ignore("unused_signal")
signal on_fade_in_finished()

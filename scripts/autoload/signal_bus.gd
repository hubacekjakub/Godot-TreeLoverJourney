extends Node


# Map events

# called when stretcher reached new resting place
@warning_ignore("unused_signal")
signal resting_place_reached()

# called when new location for resting place is set
@warning_ignore("unused_signal")
signal new_resting_place_set(new_resting_place: RestingPlace)

# called when new map is loaded
@warning_ignore("unused_signal")
signal map_loaded(map_name: String)

#UnitDirector

# called when new unit is selected
@warning_ignore("unused_signal")
signal on_unit_selected(unit: FriendlyUnit)

# called when unit is deselected
@warning_ignore("unused_signal")
signal on_unit_deselected(unit: FriendlyUnit)

# called when unit is lost of the screen
@warning_ignore("unused_signal")
signal on_unit_lost(unit: FriendlyUnit)

#NightDirector

# called when night gameplay starts
@warning_ignore("unused_signal")
signal on_night_start(level: int)

# called when night gameplay ends
@warning_ignore("unused_signal")
signal on_night_end(success: bool)

# called when an enemy unit is purged
@warning_ignore("unused_signal")
signal on_enemy_purged(enemy_unit: EnemyUnit)

#Resoruces

# called when a resource is collected
@warning_ignore("unused_signal")
signal on_resource_collected(resource: Supply.ResoruceType, amount: int)
# called when a resources are updated
@warning_ignore("unused_signal")
signal on_resource_updated()

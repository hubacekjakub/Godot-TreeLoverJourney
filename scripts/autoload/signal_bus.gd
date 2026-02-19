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
signal on_unit_selected(unit: CollectorUnit)

# called when unit is deselected
@warning_ignore("unused_signal")
signal on_unit_deselected(unit: CollectorUnit)

# called when unit is lost of the screen
@warning_ignore("unused_signal")
signal on_unit_lost(unit: CollectorUnit)

#Resoruces

# called when a resource is collected
@warning_ignore("unused_signal")
signal on_resource_collected(resource: Supply.ResoruceType, amount: int)
# called when a resources are updated
@warning_ignore("unused_signal")
signal on_resource_updated()

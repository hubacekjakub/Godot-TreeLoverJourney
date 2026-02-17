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

extends Node


# Map events
signal resting_place_reached()
signal new_resting_place_set(new_resting_place: RestingPlace)

signal map_loaded(map_name: String)

extends Node

const MAIN_MENU = "uid://day083c7paac0"
const MAIN_LEVEL = "uid://cy8unddt2maqp"
const NIGHT_LEVEL = "uid://b5rwrjnjnbf1c"


@export var main_menu_sound: AudioStream
@export var day_time_sound: AudioStream
@export var night_time_sound: AudioStream
@export var food_picked_sound: AudioStream
@export var water_picked_sound: AudioStream

@onready var main_audio_stream_player: AudioStreamPlayer = $MainAudioStreamPlayer
@onready var sound_effect_audio_stream_player: AudioStreamPlayer = $SoundEffectAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_audio_stream_player.stream = main_menu_sound
	SignalBus.map_loaded.connect(handle_level_loaded)
	SignalBus.on_night_start.connect(handle_night_start)
	SignalBus.on_resource_collected.connect(handle_resource_collected)
	play_music()


func handle_level_loaded(map_name: String):
	if map_name == MAIN_MENU and main_audio_stream_player.stream != main_menu_sound:
		main_audio_stream_player.stream = main_menu_sound
		play_music()
	elif map_name == NIGHT_LEVEL and main_audio_stream_player.stream != night_time_sound:
		main_audio_stream_player.stream = night_time_sound
		play_music()
	elif map_name == MAIN_LEVEL and main_audio_stream_player.stream != day_time_sound:
		main_audio_stream_player.stream = day_time_sound
		play_music()


func stop_music() -> void:
	main_audio_stream_player.stop()


func play_music() -> void:
	main_audio_stream_player.play()


func handle_night_start(_level: int) -> void:
	main_audio_stream_player.stream = night_time_sound
	main_audio_stream_player.play()

func handle_resource_collected(resource: Supply.ResoruceType, _amount: int) -> void:
	if resource == 0: # food
		sound_effect_audio_stream_player.stream = food_picked_sound
	elif resource == 1: # water
		sound_effect_audio_stream_player.stream = water_picked_sound

	#sound_effect_audio_stream_player.play()

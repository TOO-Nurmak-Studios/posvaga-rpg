extends Node

const music_path_prefix = "res://music/"
const env_path_prefix = "res://sfx/env/"
const sound_path_prefix = "res://sfx/"

const no_music_symbol = "."
const no_env_symbol = "."

const use_default_volume_symbol = "."
const use_default_down_seconds_symbol = "."
const use_default_up_seconds_symbol = "."

const default_down_seconds = 0
const default_up_seconds = 0

const default_music_volume = -7
const default_env_volume = 0
const default_sound_volume = 0

const min_volume = -80

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer
@onready var env_player: AudioStreamPlayer = $EnvPlayer

var current_music_file: String = ""
var current_music_position: float = 0.0
var current_env_file: String = ""
var current_env_position: float = 0.0

var tween_music: Tween
var tween_env: Tween

var prev_music_file: String


func _ready():
	EventBus.music_play_new.connect(play_new_music)
	EventBus.music_play.connect(play_music)
	EventBus.music_pause.connect(pause_music)
	EventBus.music_stop.connect(stop_music)
	EventBus.music_replace.connect(replace_music)
	EventBus.music_replace_back.connect(replace_back_music)
	EventBus.sound_play.connect(play_sound)
	EventBus.env_play_new.connect(play_new_env)
	EventBus.env_play.connect(play_env)
	EventBus.env_pause.connect(pause_env)
	EventBus.env_stop.connect(stop_env)

## music


func play_new_music(
					music_file: String,
					down_seconds: String,
					up_seconds: String,
					volume: String):
	
	if music_file == current_music_file:
		return
	
	var actual_down_seconds = float_or_default(down_seconds, use_default_down_seconds_symbol, default_down_seconds)
	var actual_up_seconds = float_or_default(up_seconds, use_default_up_seconds_symbol, default_up_seconds)
	var actual_volume = float_or_default(volume, use_default_volume_symbol, default_music_volume)
	
	if music_file == no_music_symbol || music_file == null || music_file.is_empty():
		stop_music(actual_down_seconds)
		return
	
	var new_music_callable = func(): do_play_new_music(music_file, actual_up_seconds, actual_volume)
	stop_music_and_call(actual_down_seconds, new_music_callable)


func do_play_new_music(music_file: String, up_seconds: float, volume: float):
	music_player.stream = load(music_path_prefix + music_file)
	current_music_file = music_file
	play_music(up_seconds, volume)


func play_music(up_seconds: float, volume: float):
	music_player.play(current_music_position)
	
	if up_seconds == 0:
		music_player.volume_db = volume
		return
	
	if tween_music:
		tween_music.kill()
	tween_music = create_tween()
	tween_music.tween_property(music_player, "volume_db", volume, up_seconds)


func pause_music():
	current_music_position = music_player.get_playback_position()
	music_player.stop()


func stop_music(down_seconds: float):
	stop_music_and_call(down_seconds, do_nothing)

func replace_music(new_music: String):
	prev_music_file = current_music_file
	play_new_music(new_music, ".", ".", ".")

func replace_back_music():
	if prev_music_file == "":
		return
	var music_to_play = prev_music_file
	prev_music_file = ""
	play_new_music(music_to_play, ".", ".", ".")

func stop_music_and_call(down_seconds: float, callable: Callable):
	if down_seconds == 0:
		do_stop_music_and_call(callable)
		return
		
	if tween_music:
		tween_music.kill()
	tween_music = create_tween()
	tween_music.tween_property(music_player, "volume_db", min_volume, down_seconds)
	tween_music.connect("finished", func(): do_stop_music_and_call(callable))


func do_stop_music_and_call(callable: Callable):
	music_player.stop()
	music_player.volume_db = min_volume
	current_music_file = ""
	current_music_position = 0.0
	callable.call()


## sound


func play_sound(sound_file: String, volume: String):
	
	var actual_volume = float_or_default(volume, use_default_volume_symbol, default_sound_volume)
	
	if sound_player.playing:
		sound_player.stop()
	sound_player.stream = load(sound_path_prefix + sound_file)
	sound_player.volume_db = actual_volume
	sound_player.play()


## env


func play_new_env(
					env_file: String,
					down_seconds: String,
					up_seconds: String,
					volume: String):
	
	if env_file == current_env_file:
		return
	
	var actual_down_seconds = float_or_default(down_seconds, use_default_down_seconds_symbol, default_down_seconds)
	var actual_up_seconds = float_or_default(up_seconds, use_default_up_seconds_symbol, default_up_seconds)
	var actual_volume = float_or_default(volume, use_default_volume_symbol, default_env_volume)
	
	if env_file == no_env_symbol || env_file == null || env_file.is_empty():
		stop_env(actual_down_seconds)
		return
	
	var new_env_callable = func(): do_play_new_env(env_file, actual_up_seconds, actual_volume)
	stop_env_and_call(actual_down_seconds, new_env_callable)


func do_play_new_env(env_file: String, up_seconds: float, volume: float):
	env_player.stream = load(env_path_prefix + env_file)
	current_env_file = env_file
	play_env(up_seconds, volume)


func play_env(up_seconds: float, volume: float):
	env_player.play(current_env_position)
	
	if up_seconds == 0:
		env_player.volume_db = volume
		return
	
	if tween_env:
		tween_env.kill()
	tween_env = create_tween()
	tween_env.tween_property(env_player, "volume_db", volume, up_seconds)


func pause_env():
	current_env_position = env_player.get_playback_position()
	env_player.stop()


func stop_env(down_seconds: float):
	stop_env_and_call(down_seconds, do_nothing)


func stop_env_and_call(down_seconds: float, callable: Callable):
	if down_seconds == 0:
		do_stop_env_and_call(callable)
		return
		
	if tween_env:
		tween_env.kill()
	tween_env = create_tween()
	tween_env.tween_property(env_player, "volume_db", min_volume, down_seconds)
	tween_env.connect("finished", func(): do_stop_env_and_call(callable))


func do_stop_env_and_call(callable: Callable):
	env_player.stop()
	env_player.volume_db = min_volume
	current_env_file = ""
	current_env_position = 0.0
	callable.call()

## common

func float_or_default(str: String, use_default_symbol: String, default: float) -> float:
	var actual = default
	if str != use_default_symbol:
		actual = str.to_float()
	return actual


func do_nothing():
	pass

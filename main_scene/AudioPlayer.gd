extends Node

const music_path_prefix = "res://music/"
const sound_path_prefix = "res://sfx/"
const no_music_symbol = "."
const use_default_volume_symbol = "."
const use_default_down_seconds_symbol = "."
const use_default_up_seconds_symbol = "."
const default_down_seconds = 0
const default_up_seconds = 0
const default_music_volume = -7
const default_sound_volume = 0
const min_volume = -80

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer

var current_music_file: String = ""
var current_music_position: float = 0.0
var tween: Tween

func _ready():
	EventBus.music_play_new.connect(play_new_music)
	EventBus.music_play.connect(play_music)
	EventBus.music_pause.connect(pause_music)
	EventBus.music_stop.connect(stop_music)
	EventBus.sound_play.connect(play_sound)


func _process(delta):
	pass


func play_new_music(music_file: String,
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
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(music_player, "volume_db", volume, up_seconds)


func pause_music():
	current_music_position = music_player.get_playback_position()
	music_player.stop()


func stop_music(down_seconds: float):
	stop_music_and_call(down_seconds, do_nothing)


func stop_music_and_call(down_seconds: float, callable: Callable):
	if down_seconds == 0:
		do_stop_music_and_call(callable)
		return
		
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(music_player, "volume_db", min_volume, down_seconds)
	tween.connect("finished", func(): do_stop_music_and_call(callable))


func do_stop_music_and_call(callable: Callable):
	music_player.stop()
	current_music_file = ""
	current_music_position = 0.0
	callable.call()


func play_sound(sound_file: String):
	if sound_player.playing:
		sound_player.stop()
	sound_player.stream = load(sound_path_prefix + sound_file)
	sound_player.play()


func float_or_default(str: String, use_default_symbol: String, default: float) -> float:
	var actual = default
	if str != use_default_symbol:
		actual = str.to_float()
	return actual


func do_nothing():
	pass

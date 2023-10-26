class_name AudioPlayer

extends Node

const music_path_prefix = "res://music/"
const sound_path_prefix = "res://sfx/"
const no_music_symbol = "."

@onready var music_player = $MusicPlayer
@onready var sound_player = $SoundPlayer

var current_music_file: String = ""
var current_music_position: float = 0.0

func _ready():
	EventBus.music_play_new.connect(play_new_music)
	EventBus.music_play.connect(play_music)
	EventBus.music_pause.connect(pause_music)
	EventBus.music_stop.connect(stop_music)
	EventBus.sound_play.connect(play_sound)


func _process(delta):
	pass


func play_new_music(music_file: String):
	if music_file == no_music_symbol || music_file == null || music_file.is_empty():
		stop_music()
		return
	
	if music_file != current_music_file:
		music_player.stream = load(music_path_prefix + music_file)
		current_music_file = music_file
		play_music()


func play_music():
	music_player.play(current_music_position)


func pause_music():
	current_music_position = music_player.get_playback_position()
	music_player.stop()


func stop_music():
	music_player.stop()
	current_music_file = ""
	current_music_position = 0.0


func play_sound(sound_file: String):
	if sound_player.playing:
		sound_player.stop()
	sound_player.stream = load(sound_path_prefix + sound_file)
	sound_player.play()

class_name ReplicasBox

extends Control

@export
var delay_multiplier: float = 4
@export
var min_pitch: float = 0.7
@export
var max_pitch: float = 0.8

@onready var speaker_name_label = $SpeakerNameLabel
@onready var text_label = $TextLabel

var full_text: String
var seconds_before_next_symbol: float
var is_printing: bool
var print_sound_path: String
var audio_source: AudioStreamPlayer

func _ready():
	audio_source = get_node("AudioStreamPlayer")

func _process(delta):
	pass

func set_print_sound_path(_print_sound_path: String):
	if (print_sound_path != _print_sound_path):
		audio_source.stream = load(_print_sound_path)
		print_sound_path = _print_sound_path

func set_replica(replica: ReplicaData):
	speaker_name_label.text = replica.speaker.name# + ":"
	text_label.text = ""
	full_text = replica.text
	seconds_before_next_symbol = 1 / replica.speed
	is_printing = true
	print_text()

func print_text():
	var prev_char = ''
	for char in full_text:
		await get_tree().create_timer(get_delay(prev_char, char)).timeout
		if !is_space(char):
			play_sound()
		if (not is_printing):
			return
		text_label.text += char
		prev_char = char
	is_printing = false
	
func show_full_text():
	text_label.text = full_text
	is_printing = false

func play_sound():
	audio_source.stop()
	audio_source.pitch_scale = randf_range(min_pitch, max_pitch)
	audio_source.play()

func is_space(char):
	return " \n\t".contains(char)

func is_punctiation(char):
	return ".,?!:;-".contains(char)

func get_delay(prev_char, next_char):
	if is_punctiation(prev_char) or next_char == '\n':
		return seconds_before_next_symbol * delay_multiplier
	else:
		return seconds_before_next_symbol;

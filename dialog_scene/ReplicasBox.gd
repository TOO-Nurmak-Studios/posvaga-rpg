class_name ReplicasBox

extends Control

signal printing_finished()

@export var delay_multiplier: float = 4
@export var min_pitch: float = 0.7
@export var max_pitch: float = 0.8
@export var missing_speaker_pitch_offset = -0.1

@export var max_short_name_length: int = 14

@onready var speaker_name_label = $SpeakerNameLabel
@onready var speaker_name_frame = $SpeakerNameFrame
@onready var speaker_name_long_frame = $SpeakerNameLongFrame
@onready var text_label = $TextLabel
@onready var sound_player = $PrintSoundPlayer

var full_text: String
var seconds_before_next_symbol: float
var is_printing: bool
var print_sound_path: String

var pitch_offset = 0

func _ready():
	pass

func _process(delta):
	pass

func set_print_sound_path(_print_sound_path: String):
	if (print_sound_path != _print_sound_path):
		sound_player.stream = load(_print_sound_path)
		print_sound_path = _print_sound_path

func new_replica(replica: ReplicaData):
	
	if replica.speaker != null:
		speaker_name_label.text = replica.speaker.name
		pitch_offset = replica.speaker.pitch_offset
		
		if replica.speaker.name.length() > max_short_name_length:
			speaker_name_frame.hide()
			speaker_name_long_frame.show()
		else:
			speaker_name_frame.show()
			speaker_name_long_frame.hide()
	else:
		# прячем плашку с именем персонажа, если спикер отсутствует
		speaker_name_long_frame.hide()
		speaker_name_frame.hide()
		speaker_name_label.text = ""
		
		pitch_offset = missing_speaker_pitch_offset
		
	text_label.text = ""
	full_text = replica.text
	seconds_before_next_symbol = 1 / replica.text_speed
	is_printing = true
	print_text()

func clear():
	text_label.text = ""

func print_text():
	var prev_char = ''
	for char in full_text:
		await get_tree().create_timer(get_delay(prev_char, char)).timeout
		if !is_space(char) && !is_punctiation(char):
			play_print_sound()
		if (not is_printing):
			return
		text_label.text += char
		prev_char = char
	is_printing = false
	printing_finished.emit()
	
func show_full_text():
	text_label.text = full_text
	is_printing = false
	printing_finished.emit()

func play_print_sound():
	sound_player.stop()
	sound_player.pitch_scale = randf_range(min_pitch + pitch_offset, max_pitch + pitch_offset)
	sound_player.play()

func is_space(char):
	return " \n\t".contains(char)

func is_punctiation(char):
	return ".,?!:;-()\"\"".contains(char)

func get_delay(prev_char, next_char):
	if (is_punctiation(prev_char) && is_space(next_char)) || next_char == '\n':
		return seconds_before_next_symbol * delay_multiplier
	else:
		return seconds_before_next_symbol;

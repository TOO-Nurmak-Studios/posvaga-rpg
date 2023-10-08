extends Node2D

var speech_box: SpeechBox
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speakers: Array
var speakers_to_indices = {}
var current_speaker: Speaker
var speech_units: Array
var current_unit_idx: int

# Called when the node enters the scene tree for the first time.
func _ready():
	speech_box = get_node("CanvasLayer/SpeechBox")
	init_speakers()
	init_speech_units()
	current_unit_idx = -1
	next_speech_unit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init_speech_units():
	## TODO: load
	speech_units.resize(100)
	speech_units[0] = SpeechUnit.new("Дима", "Вы знаете, зачем мы здесь собрались?")
	speech_units[1] = SpeechUnit.new("Гриша", "Нет.")
	speech_units[2] = SpeechUnit.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос...")

func init_speakers():
	## TODO: load
	var speakers_data: Array
	speakers_data.resize(2)
	speakers_data[0] = SpeakerData.new("Дима", "res://sprites/dima.png", SpeakerData.Location.LEFT)
	speakers_data[1] = SpeakerData.new("Гриша", "res://sprites/grisha.png", SpeakerData.Location.RIGHT)
	
	speakers.resize(2)
	
	var counter = 0
	for speaker_data in speakers_data:
		var speaker_instance = speaker_scene.instantiate()
		speaker_instance.name = speaker_data.speaker_name
		speaker_instance.init(load(speaker_data.texture_path), speaker_data.location, 320, get_viewport_rect().size)
		speakers[counter] = speaker_instance
		speakers_to_indices[speaker_data.speaker_name] = counter
		add_child(speaker_instance)
		counter += 1

func next_speech_unit():
	if (current_unit_idx >= 0):
		current_speaker.disappear()
	current_unit_idx += 1
	var current_unit = speech_units[current_unit_idx]
	speech_box.set_unit(current_unit)
	current_speaker = speakers[speakers_to_indices[current_unit.speaker]]
	current_speaker.appear()

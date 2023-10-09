extends Node2D

signal dialogue_finished

var replicas_box: ReplicasBox
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speakers: Array
var speakers_to_indices = {}
var current_speaker: Speaker
var units: Array
var current_unit_idx: int

func _ready():
	replicas_box = get_node("CanvasLayer/ReplicasBox")
	var data = create_dialogue_data()
	init_speakers(data)
	init_units(data)
	current_unit_idx = 0
	next()

func _process(delta):
	pass

## TODO: replace with loading
func create_dialogue_data():
	var _units: Array
	_units.resize(3)
	_units[0] = DialogueUnit.new(ReplicaData.new("Дима", "Вы знаете, зачем мы здесь собрались?"), null)
	_units[1] = DialogueUnit.new(ReplicaData.new("Гриша", "Нет."), null)
	_units[2] = DialogueUnit.new(ReplicaData.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос.."), null)
	var _speakers: Array
	_speakers.resize(2)
	_speakers[0] = SpeakerData.new("Дима", "res://sprites/dima.png", SpeakerData.Location.LEFT)
	_speakers[1] = SpeakerData.new("Гриша", "res://sprites/grisha.png", SpeakerData.Location.RIGHT)
	return DialogueData.new(_speakers, _units)

func init_speakers(data: DialogueData):
	var counter = 0
	speakers.resize(data.speakers.size())
	for speaker_data in data.speakers:
		var speaker_instance = speaker_scene.instantiate()
		speaker_instance.name = speaker_data.speaker_name
		speaker_instance.init(load(speaker_data.texture_path), speaker_data.location, 320, get_viewport_rect().size)
		speakers[counter] = speaker_instance
		speakers_to_indices[speaker_data.speaker_name] = counter
		add_child(speaker_instance)
		counter += 1

func init_units(data: DialogueData):
	units = data.units

func next():
	if current_unit_idx == units.size():
		finish()
		return
		
	if current_unit_idx >= 1:
		current_speaker.disappear()
	
	var current_unit = units[current_unit_idx]
	replicas_box.set_replica(current_unit.replica)
	current_speaker = speakers[speakers_to_indices[current_unit.replica.speaker_name]]
	current_speaker.appear()
	
	current_unit_idx += 1

func finish():
	print("dialogue finished")
	dialogue_finished.emit()

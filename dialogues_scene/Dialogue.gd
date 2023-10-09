extends Node2D

signal dialogue_finished

var replicas_box: ReplicasBox
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speakers: Array
var speakers_to_indices = {}
var current_speaker: Speaker
var replicas: Array
var current_replica_idx: int

func _ready():
	replicas_box = get_node("CanvasLayer/ReplicasBox")
	var data = create_dialogue_data()
	init_speakers(data)
	init_replicas(data)
	current_replica_idx = 0
	next_replica()

func _process(delta):
	pass

## TODO: replace with loading
func create_dialogue_data():
	var _replicas: Array
	_replicas.resize(3)
	_replicas[0] = ReplicaData.new("Дима", "Вы знаете, зачем мы здесь собрались?")
	_replicas[1] = ReplicaData.new("Гриша", "Нет.")
	_replicas[2] = ReplicaData.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос..")
	var _speakers: Array
	_speakers.resize(2)
	_speakers[0] = SpeakerData.new("Дима", "res://sprites/dima.png", SpeakerData.Location.LEFT)
	_speakers[1] = SpeakerData.new("Гриша", "res://sprites/grisha.png", SpeakerData.Location.RIGHT)
	return DialogueData.new(_speakers, _replicas)

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

func init_replicas(data: DialogueData):
	replicas = data.replicas

func next_replica():
	if current_replica_idx == replicas.size():
		finish()
		return
		
	if current_replica_idx >= 1:
		current_speaker.disappear()
	
	var current_replica = replicas[current_replica_idx]
	replicas_box.set_replica(current_replica)
	current_speaker = speakers[speakers_to_indices[current_replica.speaker_name]]
	current_speaker.appear()
	
	current_replica_idx += 1

func finish():
	print("dialogue finished")
	dialogue_finished.emit()

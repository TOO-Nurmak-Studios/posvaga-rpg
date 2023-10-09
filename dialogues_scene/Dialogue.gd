extends Node2D

signal dialogue_finished

var replicas_box: ReplicasBox
var choices_box: ChoicesBox
var next_button: Button
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speakers: Array
var speakers_to_indices = {}
var current_speaker: Speaker
var units: Array
var next_unit_idx: int

func _ready():
	next_button = get_node("CanvasLayer/NextButton")
	replicas_box = get_node("CanvasLayer/ReplicasBox")
	choices_box = get_node("CanvasLayer/ChoicesBox")
	choices_box.hide()
	var data = create_dialogue_data()
	init_speakers(data)
	init_units(data)
	next_unit_idx = 0
	next()

func _process(delta):
	pass

## TODO: replace with loading
func create_dialogue_data():
	var _units: Array
	_units.resize(6)
	_units[0] = DialogueUnit.new(0, ReplicaData.new("Дима", "Вы знаете, зачем мы здесь собрались?"), [])
	_units[1] = DialogueUnit.new(1, ReplicaData.new("Гриша", "Нет."), [])
	_units[2] = DialogueUnit.new(2, ReplicaData.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос.."), [])
	_units[3] = DialogueUnit.new(3, ReplicaData.new("Гриша", "..."), [ChoiceOptionData.new(ChoiceOptionData.Type.REPLICA, "Не надо...", 4), ChoiceOptionData.new(ChoiceOptionData.Type.REPLICA, "Щас тебя порешаю", 5)])
	_units[4] = DialogueUnit.new(2, ReplicaData.new("Дима", "<Взрыв>"), [])
	_units[5] = DialogueUnit.new(2, ReplicaData.new("Дима", "Чё тявкнул, Бобик?"), [])
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
	if next_unit_idx == units.size():
		finish()
		return
		
	if next_unit_idx >= 1:
		current_speaker.disappear()
	
	var current_unit = units[next_unit_idx]
	replicas_box.set_replica(current_unit.replica)
	current_speaker = speakers[speakers_to_indices[current_unit.replica.speaker_name]]
	current_speaker.appear()
	
	if (current_unit.choice_options.size() > 0):
		next_button.hide()
		choices_box.show()
		choices_box.init(current_unit.choice_options)
	else:
		next_unit_idx += 1

func finish():
	print("dialogue finished")
	dialogue_finished.emit()

func _on_choices_box_option_chosen():
	var chosen_option = choices_box.chosen_option
	choices_box.hide()
	next_button.show()
	next_unit_idx = chosen_option.next_unit_id
	next()

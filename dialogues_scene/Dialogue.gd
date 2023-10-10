extends Node2D

signal dialogue_finished
signal option_chosen(option_id: String)

var replicas_box: ReplicasBox
var choices_box: ChoicesBox
var next_button: Button
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speakers: Array
var speakers_to_indices = {}
var current_speaker: Speaker
var units: Array
var next_unit_id: int

func _ready():
	next_button = get_node("CanvasLayer/NextButton")
	replicas_box = get_node("CanvasLayer/ReplicasBox")
	choices_box = get_node("CanvasLayer/ChoicesBox")
	choices_box.hide()
	var data = create_dialogue_data()
	init_speakers(data)
	init_units(data)
	next_unit_id = 0
	next()

func _process(delta):
	pass

## TODO: replace with loading
func create_dialogue_data():
	var _units: Array
	_units.resize(6)
	_units[0] = DialogueUnit.new(0, ReplicaData.new("Дима", "Вы знаете, зачем мы здесь собрались?", 20), [], 1)
	_units[1] = DialogueUnit.new(1, ReplicaData.new("Гриша", "Нет.", 10), [], 2)
	_units[2] = DialogueUnit.new(2, ReplicaData.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос..", 20), [], 3)
	_units[3] = DialogueUnit.new(3, ReplicaData.new("Гриша", "...", 2), [ChoiceOptionData.new("grisha-pls-no", "Не надо...", 4), ChoiceOptionData.new("grisha-eff", "Щас тебя порешаю", 5)], -1)
	_units[4] = DialogueUnit.new(4, ReplicaData.new("Дима", "<Взрыв>", 30), [], 6)
	_units[5] = DialogueUnit.new(5, ReplicaData.new("Дима", "Чё тявкнул, Бобик?", 5), [], 7)
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
	if replicas_box.is_printing:
		replicas_box.show_full_text()
		return
	
	if next_unit_id >= units.size():
		finish()
		return
		
	if next_unit_id >= 1:
		current_speaker.disappear()
	
	var current_unit = units[next_unit_id]
	replicas_box.set_replica(current_unit.replica)
	current_speaker = speakers[speakers_to_indices[current_unit.replica.speaker_name]]
	current_speaker.appear()
	
	if (current_unit.choice_options.size() > 0):
		next_button.hide()
		choices_box.show()
		choices_box.init(current_unit.choice_options)
	else:
		next_unit_id = current_unit.next_unit_id

func finish():
	print("dialogue finished")
	dialogue_finished.emit()

func _on_choices_box_option_chosen():
	var chosen_option = choices_box.chosen_option
	choices_box.hide()
	next_button.show()
	next_unit_id = chosen_option.next_unit_id
	option_chosen.emit(chosen_option.id)
	next()

## TODO: for tests, remove
func _on_option_chosen(option_id):
	print(option_id)

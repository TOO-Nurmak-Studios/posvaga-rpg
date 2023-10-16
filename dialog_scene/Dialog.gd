extends CanvasLayer

signal option_chosen(option_id: String)

@export var ink_file: Resource
@export var speakers_bottom: float = 400
@export var speakers_speed: float = 1000

@onready var ink_player = $InkPlayer
@onready var replicas_box = $ReplicasBox
@onready var choices_box = $ChoicesBox

var speaker_scene: PackedScene = load("res://dialog_scene/speaker.tscn")

var speakers_data: Dictionary	## String to SpeakerData
var speakers: Dictionary = {}	## String to Speaker
var current_speaker_name: String = ""
var dialog_data: DialogData
var waiting_for_choice: bool


## TODO: replace with loading (from where?)
func create_speakers_data() -> Dictionary:
	return {
		"dean_angry"      : SpeakerData.new("dean_angry", "Декан"),
		"dean_neutral"    : SpeakerData.new("dean_neutral", "Декан"),
		"dean_smiling"    : SpeakerData.new("dean_smiling", "Декан"),

		"student_neutral" : SpeakerData.new("student_neutral", "Студент"),
		"student_welcome" : SpeakerData.new("student_welcome", "Студент")
	}


func _ready():
	ink_player.loads_in_background = false

	hide()

	EventBus.dialog_start.connect(start)

	init_speakers()

	# для отладки самой сцены стартуем сразу,
	# иначе показываем только при вызове start
	if get_tree().current_scene == self:
		var test_dialog = DialogData.new(ink_file, false, [])
		start(test_dialog)


func _process(delta):
	if Input.is_action_just_pressed("dialog_next") and !waiting_for_choice:
		next()


func init_speakers():
	speakers_data = create_speakers_data()
	for speaker_data in speakers_data.values():
		if speakers.get(speaker_data.name) == null:
			var speaker_instance = speaker_scene.instantiate()
			speaker_instance.init(speakers_bottom, get_viewport_rect().size, speakers_speed)
			canvas_layer.add_child(speaker_instance)
			speaker_instance.hide()
			speakers[speaker_data.name] = speaker_instance


func start(_dialog_data: DialogData):
	dialog_data = _dialog_data
	
	ink_player.ink_file = dialog_data.ink_file
	ink_player.create_story()
	await ink_player.loaded
	
	# загружаем игровые переменные в инк
	for var_name in dialog_data.var_names:
		var var_val = GameState.vars.get(var_name)
		if var_val != null:
			ink_player.set_variable(var_name, var_val)

	get_tree().paused = true
	show()
	next()


func next():
	if replicas_box.is_printing:
		replicas_box.show_full_text()
		return

	if !ink_player.has_choices && !ink_player.can_continue:
		finish()
		return

	if ink_player.can_continue:
		var next_replica_text = ink_player.continue_story()
		var tags = ink_player.current_tags
		process_next_replica(next_replica_text, tags)

	if ink_player.has_choices:
		await replicas_box.printing_finished
		waiting_for_choice = true
		choices_box.init(ink_player.current_choices)
		choices_box.show()


func process_next_replica(replica_text: String, tags: Array):
	var replica = parse_next_replica(replica_text, tags)
	await process_next_speaker(replica.speaker, replica.speaker_location)
	replicas_box.new_replica(replica)


func parse_next_replica(replica_text: String, tags: Array) -> ReplicaData:
	var speaker_id = null
	var speaker_data = null
	var speaker_location = ReplicaData.SpeakerLocation.LEFT
	var text_speed = 20

	# хочется использовать лейбл c html-форматированием, типа TextMeshPro
	# пока варварским способом попробовал поддержать перенос строки
	replica_text = replica_text.replace("<br>", "\n")

	for tag in tags:
		var split = tag.split(": ")
		var tag_name = split[0]
		var tag_value = split[1]

		match tag_name:
			"sid":
				speaker_id = tag_value
			"loc":
				speaker_location = ReplicaData.SpeakerLocation.get(tag_value.to_upper())
			"spd":
				text_speed = tag_value.to_int()

	if speaker_id != null:
		speaker_data = speakers_data[speaker_id]

	return ReplicaData.new(speaker_data, replica_text, speaker_location as ReplicaData.SpeakerLocation, text_speed)


func process_next_speaker(speaker_data: SpeakerData, location: ReplicaData.SpeakerLocation):
	var speaker_name = speaker_data.name
	var speaker = speakers[speaker_name]
	var is_new_speaker = speaker_name != current_speaker_name
	
	speaker.update(location, speaker_data.texture)
	
	if is_new_speaker:
		if not current_speaker_name.is_empty():
			await speakers[current_speaker_name].disappear()
		speaker.set_disappeared()
		speaker.show()
		await speaker.appear()
	else:
		speaker.set_appeared()
	
	current_speaker_name = speaker_name


func finish():
	# выгружаем игровые переменные в глобальный стейт
	for var_name in dialog_data.var_names:
		var var_val = ink_player.get_variable(var_name)
		GameState.vars[var_name] = var_val
	
	get_tree().paused = false
	hide()
	EventBus.dialog_finished.emit()
	print("dialog finished")

func _on_choices_box_option_chosen(option_id: int):
	ink_player.choose_choice_index(option_id)
	choices_box.hide()
	option_chosen.emit(option_id)
	waiting_for_choice = false
	next()


## TODO: for tests, remove
func _on_option_chosen(option_id):
	print(option_id)

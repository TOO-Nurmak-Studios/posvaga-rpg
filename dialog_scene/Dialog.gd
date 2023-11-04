extends CanvasLayer

signal option_chosen(option_id: String)

const back_color_on_start = Color(0, 0, 0, 0)
const back_color_showed = Color(0, 0, 0, 0.5)
const back_change_color_seconds = 0.3

@export var ink_file: Resource
@export var speakers_bottom: float = 360
@export var speakers_speed: float = 2000

@onready var ink_player = $InkPlayer
@onready var replicas_box = $ReplicasBox
@onready var choices_box = $ChoicesBox
@onready var color_rect = $ColorRect

var speaker_scene: PackedScene = load("res://dialog_scene/speaker.tscn")

var speakers_data: Dictionary	## String to SpeakerData
var speakers: Dictionary = {}	## String to Speaker
var current_speakers_names: Array[String]
var dialog_data: DialogData
var waiting_for_choice: bool
var may_show_next: bool
var main_speaker_id: String
var is_cutscene: bool


func _ready():
	ink_player.loads_in_background = false

	hide()
	init_speakers()

	EventBus.dialog_start.connect(start)
	EventBus.cutscene_step_finished.connect(on_cutscene_step_finished)

	# для отладки самой сцены стартуем сразу,
	# иначе показываем только при вызове start
	if get_tree().current_scene == self:
		var test_dialog = DialogData.new(ink_file, [])
		start(test_dialog)


func _process(delta):
	if Input.is_action_just_pressed("dialog_next"):
		try_next()
	if Input.is_action_just_pressed("dialog_focus_options") and waiting_for_choice:
		if not choices_box.is_focused:
			choices_box.focus_on_first_option()


func init_speakers():
	speakers_data = DialogStaticInitializer.speakers_data
	main_speaker_id = DialogStaticInitializer.main_speaker_id
	for speaker_data in speakers_data.values():
		if speakers.get(speaker_data.name) == null:
			var speaker_instance = speaker_scene.instantiate()
			speaker_instance.init(speakers_bottom, get_viewport().get_visible_rect().size, speakers_speed)
			add_child(speaker_instance)
			speaker_instance.hide()
			speakers[speaker_data.name] = speaker_instance


func start(_dialog_data: DialogData):
	dialog_data = _dialog_data
	
	ink_player.ink_file = dialog_data.ink_file
	ink_player.create_story()
	await ink_player.loaded
	
	# стартуем с заданного узла
	if dialog_data.starting_knot != null && dialog_data.starting_knot != "":
		ink_player.choose_path(dialog_data.starting_knot)
	
	# загружаем игровые переменные в инк
	for var_name in dialog_data.var_names:
		var var_val = GameState.vars.get(var_name)
		if var_val != null:
			ink_player.set_variable(var_name, var_val)

	_lock_player()
	show()
	
	color_rect.modulate = back_color_on_start
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate", back_color_showed, back_change_color_seconds)
	
	next()


func try_next():
	if is_cutscene:
		return
	elif replicas_box.is_printing:
		replicas_box.show_full_text()
	elif !waiting_for_choice and may_show_next:
		next()


func next():
	may_show_next = false
	
	if !ink_player.has_choices && !ink_player.can_continue:
		finish()
		return

	if ink_player.can_continue:
		var next_text = ink_player.continue_story()
		var tags = ink_player.current_tags
		await process_next_unit(next_text, tags)

	if ink_player.has_choices:
		await replicas_box.printing_finished
		waiting_for_choice = true
		choices_box.init(ink_player.current_choices)
		## TODO: what if that is not main speaker who's choosing?
		await process_next_speaker(speakers_data[main_speaker_id], ReplicaData.SpeakerLocation.DEFAULT, false)
		choices_box.show()
		
	may_show_next = true


func process_next_unit(text: String, tags: Array):
	var parsed_tags = parse_tags(tags)
	
	var sound_tag = find_sound_tag(parsed_tags)
	var music_tag = find_music_tag(parsed_tags)
	
	if sound_tag != null:
		process_next_sound(sound_tag.params[0])
		parsed_tags.erase(sound_tag)
		
	if music_tag != null:
		process_next_music(music_tag.params)
		parsed_tags.erase(music_tag)
	
	if parsed_tags.size() == 0 || parsed_tags[0].type != DialogTag.Type.CUTSCENE_STEP:
		await process_next_replica(text, parsed_tags)
	else:
		hide_current_speakers(true)
		await process_next_cutscene_step(parsed_tags[0].params[0], text)


func parse_tags(tags: Array) -> Array[DialogTag]:
	var parsed: Array[DialogTag] = []
	parsed.resize(tags.size())
	
	for i in range(tags.size()):
		parsed[i] = DialogTag.new(tags[i])
		
	return parsed


func find_sound_tag(tags: Array[DialogTag]):
	for tag in tags:
		if tag.type == DialogTag.Type.SOUND:
			return tag
	return null

func find_music_tag(tags: Array[DialogTag]):
	for tag in tags:
		if tag.type == DialogTag.Type.MUSIC:
			return tag
	return null

func process_next_cutscene_step(type: String, description: String):
	if not is_cutscene:
		## TODO: make it smooth
		hide()
		is_cutscene = true
	
	var step = CutsceneStep.new(type, description)
	EventBus.cutscene_step_start.emit(step)


func process_next_sound(file: String):
	EventBus.sound_play.emit(file)


func process_next_music(params: PackedStringArray):
	var file: String = params[0]
	var down_seconds = params[1]
	var up_seconds = params[2]
	var volume = params[3]
	EventBus.music_play_new.emit(file, down_seconds, up_seconds, volume)


func on_cutscene_step_finished():
	next()


func process_next_replica(replica_text: String, tags: Array[DialogTag]):
	if is_cutscene:
		## TODO: make it smooth
		show()
		is_cutscene = false
	
	var replica = parse_next_replica(replica_text, tags)
	replicas_box.new_replica(replica)
	await process_next_speaker(replica.speaker, replica.speaker_location, true)


func parse_next_replica(replica_text: String, tags: Array[DialogTag]) -> ReplicaData:
	var speaker_id = null
	var speaker_data = null
	var speaker_location = ReplicaData.SpeakerLocation.LEFT
	var text_speed = 20

	# хочется использовать лейбл c html-форматированием, типа TextMeshPro
	# пока варварским способом попробовал поддержать перенос строки
	replica_text = replica_text.replace("<br>", "\n")

	for tag in tags:
		match tag.type:
			DialogTag.Type.SPEAKER_ID:
				speaker_id = tag.params[0]
			DialogTag.Type.SPEAKER_LOCATION:
				speaker_location = ReplicaData.SpeakerLocation.get(tag.params[0].to_upper())
			DialogTag.Type.SPEAKER_SPEED:
				text_speed = tag.params[0].to_int()

	if speaker_id != null:
		speaker_data = speakers_data.get(speaker_id)
	
	if speaker_data == null:
		print("Unknown speaker id: " + str(speaker_id))

	return ReplicaData.new(speaker_data, replica_text, speaker_location as ReplicaData.SpeakerLocation, text_speed)


func process_next_speaker(speaker_data: SpeakerData, location: ReplicaData.SpeakerLocation, replace: bool):
	
	# пустой либо неизвестный игре спикер
	if speaker_data == null:
		hide_current_speakers(replace)
		return
	
	var speaker_name = speaker_data.name
	var speaker = speakers[speaker_name]
	var is_new_speaker = !current_speakers_names.has(speaker_name)
	
	hide_current_speakers(replace, speaker_name)
	speaker.update(location, speaker_data)
	
	if is_new_speaker:
		speaker.set_disappeared()
		speaker.show()
		await speaker.appear()
		current_speakers_names.append(speaker_name)
	else:
		speaker.set_appeared()


# пустой speaker_name - костыль, ожидается, что такого id никогда не будет в мапе
func hide_current_speakers(replace: bool = true, speaker_name: String = ""):
	if not current_speakers_names.is_empty():
		for current_speaker_name in current_speakers_names:
			if current_speaker_name != speaker_name:
				if replace:
					current_speakers_names.erase(current_speaker_name)
					await speakers[current_speaker_name].disappear()
				else:
					speakers[current_speaker_name].dim()


func finish():
	hide_current_speakers()
	
	# выгружаем игровые переменные в глобальный стейт
	for var_name in dialog_data.var_names:
		var var_val = ink_player.get_variable(var_name)
		GameState.set_var(var_name, var_val)
	
	replicas_box.clear()
	
	_unlock_player()
	hide()
	EventBus.dialog_finished.emit()
	print("dialog finished")

func _on_choices_box_option_chosen(option_id: int):
	ink_player.choose_choice_index(option_id)
	choices_box.hide()
	option_chosen.emit(option_id)
	waiting_for_choice = false
	next()

func _lock_player():
	EventBus.player_input_enabled = false

func _unlock_player():
	EventBus.player_input_enabled = true


## TODO: for tests, remove
func _on_option_chosen(option_id):
	print(option_id)

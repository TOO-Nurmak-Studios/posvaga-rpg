extends Node2D

signal dialog_finished()
signal option_chosen(option_id: String)

@export var ink_file: Resource

@onready var ink_player = $InkPlayer
@onready var canvas_layer = $CanvasLayer
@onready var replicas_box = $CanvasLayer/ReplicasBox
@onready var choices_box = $CanvasLayer/ChoicesBox
@onready var next_button = $CanvasLayer/NextButton

var speaker_scene: PackedScene = load("res://dialog_scene/speaker.tscn")

var speakers_data = {
	"dean_angry"      : SpeakerData.new("dean_angry", "Декан"),
	"dean_neutral"    : SpeakerData.new("dean_neutral", "Декан"),
	"dean_smiling"    : SpeakerData.new("dean_smiling", "Декан"),

	"student_neutral" : SpeakerData.new("student_neutral", "Студент"),
	"student_welcome" : SpeakerData.new("student_welcome", "Студент")
}

# todo: сразу поставить на сцену?
var speakers: Array[Speaker]
var current_speaker: Speaker

func _ready():
	ink_player.loads_in_background = false

	canvas_layer.hide()
	choices_box.hide()

	EventBus.dialog_start.connect(start)

	init_speakers()

	# для отладки самой сцены стартуем сразу,
	# иначе показываем только при вызове open
	if get_tree().current_scene == self:
		start(ink_file, false)

func start(ink_file: Resource, is_cutscene: bool):
	ink_player.ink_file = ink_file
	ink_player.create_story()
	await ink_player.loaded

	get_tree().paused = true
	canvas_layer.show()
	next()

func init_speakers():
	var speaker_instance = speaker_scene.instantiate()
	speaker_instance.init(400, get_viewport_rect().size)
	canvas_layer.add_child(speaker_instance)
	current_speaker = speaker_instance

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
		display_next_replica(next_replica_text, tags)

	if ink_player.has_choices:
		next_button.hide()
		choices_box.init(ink_player.current_choices)
		choices_box.show()


func display_next_replica(replica_text: String, tags: Array):
	var replica = parse_next_replica(replica_text, tags)
	replicas_box.set_replica(replica)
	current_speaker.set_texture(replica.speaker.texture, replica.speaker_location)


func parse_next_replica(replica_text: String, tags: Array) -> ReplicaData:
	var speaker_id = null
	var speaker_data = null
	var location = ReplicaData.Location.LEFT
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
				location = ReplicaData.Location.get(tag_value.to_upper())
			"spd":
				text_speed = tag_value.to_int()

	if speaker_id != null:
		speaker_data = speakers_data[speaker_id]

	return ReplicaData.new(speaker_data, replica_text, location as ReplicaData.Location, text_speed)


func finish():
	print("dialog finished")
	get_tree().paused = false
	canvas_layer.hide()
	dialog_finished.emit()

func _on_choices_box_option_chosen(index: int):
	ink_player.choose_choice_index(index)
	choices_box.hide()
	next_button.show()
	option_chosen.emit(index)
	next()

## TODO: for tests, remove
func _on_option_chosen(option_id):
	print(option_id)

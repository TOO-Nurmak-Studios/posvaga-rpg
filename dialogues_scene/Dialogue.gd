extends Node2D

var speech_box: SpeechBox
var speaker_scene: PackedScene = load("res://dialogues_scene/speaker.tscn")

var speech: Array
var current_unit_num: int

# Called when the node enters the scene tree for the first time.
func _ready():
	speech_box = get_node("CanvasLayer/SpeechBox")
	set_speech()
	current_unit_num = -1
	next_speech_unit()
	set_speakers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_speech():
	## TODO: load
	speech.resize(100)
	speech[0] = SpeechUnit.new("Дима", "Вы знаете, зачем мы здесь собрались?")
	speech[1] = SpeechUnit.new("Гриша", "Нет.")
	speech[2] = SpeechUnit.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос...")

func set_speakers():
	var speaker1: Speaker = speaker_scene.instantiate()
	speaker1.init(load("res://sprites/dima.png"), Speaker.Location.LEFT, 320, get_viewport_rect().size)
	speaker1.name = "Speaker1"
	add_child(speaker1)
	speaker1.appear()
	var speaker2: Speaker = speaker_scene.instantiate()
	speaker2.init(load("res://sprites/grisha.png"), Speaker.Location.RIGHT, 320, get_viewport_rect().size)
	speaker2.name = "Speaker2"
	add_child(speaker2)
	speaker2.appear()

func next_speech_unit():
	current_unit_num += 1
	speech_box.set_unit(speech[current_unit_num])

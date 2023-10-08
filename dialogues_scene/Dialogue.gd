extends Node2D

var speech_box: SpeechBox

var speech: Array
var current_unit_num: int

# Called when the node enters the scene tree for the first time.
func _ready():
	speech_box = get_node("CanvasLayer/SpeechBox")
	set_speech()
	current_unit_num = -1
	next_speech_unit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_speech():
	## TODO: load
	speech.resize(100)
	speech[0] = SpeechUnit.new("Дима", "Вы знаете, зачем мы здесь собрались?")
	speech[1] = SpeechUnit.new("Гриша", "Нет.")
	speech[2] = SpeechUnit.new("Дима", "Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос...")

func next_speech_unit():
	current_unit_num += 1
	speech_box.set_unit(speech[current_unit_num])

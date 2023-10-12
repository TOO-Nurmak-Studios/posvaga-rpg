class_name ChoicesBox

extends Control

signal option_chosen(index: int)

var option_buttons: Array[Button]

func _ready():
	option_buttons.resize(3)
	option_buttons[0] = get_node("Rect/Option1")
	option_buttons[0].hide()
	option_buttons[1] = get_node("Rect/Option2")
	option_buttons[1].hide()
	option_buttons[2] = get_node("Rect/Option3")
	option_buttons[2].hide()

func _process(delta):
	pass

func init(_choice_options: Array):
	for i in range(_choice_options.size()):
		option_buttons[i].text = _choice_options[i].text
		option_buttons[i].show()

func _on_option_pressed(button_idx):
	option_chosen.emit(button_idx)

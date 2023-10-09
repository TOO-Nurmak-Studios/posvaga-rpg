class_name ChoicesBox

extends Control

signal option_chosen

var option_buttons: Array
var choice_options: Array
var chosen_option: ChoiceOptionData

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
	choice_options = _choice_options
	for i in range(choice_options.size()):
		option_buttons[i].text = choice_options[i].text
		option_buttons[i].show()

func _on_option_pressed(button_idx):
	chosen_option = choice_options[button_idx]
	option_chosen.emit()

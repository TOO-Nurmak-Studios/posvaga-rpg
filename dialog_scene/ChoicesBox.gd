class_name ChoicesBox

extends Control

signal option_chosen(index: int)

@export
var px_between_buttons = 10

@onready var rect = $Rect
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
	var options_num = _choice_options.size()
	var rect_width = rect.size.x
	var rect_height = rect.size.y
	var button_width = (rect_width / options_num - px_between_buttons / 2) as int
	
	for i in range(options_num):
		option_buttons[i].text = _choice_options[i].text
		option_buttons[i].set_size(Vector2(button_width, rect_height))
		var position_x = i * (button_width + px_between_buttons)
		option_buttons[i].set_position(Vector2(position_x, 0))
		option_buttons[i].show()

func _on_option_pressed(button_idx):
	option_chosen.emit(button_idx)

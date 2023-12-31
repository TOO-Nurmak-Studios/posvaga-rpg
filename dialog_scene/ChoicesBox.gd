class_name ChoicesBox

extends Control

signal option_chosen(option_id: int)

@export var px_between_buttons = 10

@onready var rect = $Rect

var option_buttons: Array[Button]
var is_focused: bool = false

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
	var button_width = (rect_width / options_num - px_between_buttons) as int
	
	for i in range(options_num):
		option_buttons[i].text = _choice_options[i].text
		option_buttons[i].set_size(Vector2(button_width, rect_height))
		var position_x = px_between_buttons / 2 + i * (button_width + px_between_buttons)
		option_buttons[i].set_position(Vector2(position_x, 0))
		option_buttons[i].show()
		
	is_focused = false


func focus_on_first_option():
	option_buttons[0].grab_focus()
	is_focused = true


func _on_option_pressed(button_id):
	option_chosen.emit(button_id)

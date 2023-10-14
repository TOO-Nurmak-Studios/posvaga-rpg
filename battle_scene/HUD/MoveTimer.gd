class_name MoveTimer
extends Node2D

@onready var text_label: Label = $Label as Label
var current_moves: int = -1

func set_moves_amount(moves: int):
	current_moves = moves
	text_label.text = str(moves)
	var color
	if moves < 3:
		color = Color.RED
	else:
		color = Color.BLACK
	text_label.add_theme_color_override("font_color", color)

func decrement_moves():
	if current_moves != 0:
		set_moves_amount(current_moves - 1)

func set_thinking():
	text_label.add_theme_color_override("font_color", Color.BLACK)
	text_label.text = "?"

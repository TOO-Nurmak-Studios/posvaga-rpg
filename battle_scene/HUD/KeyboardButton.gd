class_name KeyboardButton
extends Button

var _text
var _font_size

func init_vars(text, font_size):
	_text = text
	_font_size = font_size

func _ready():
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)
	self.text = _text
	self.add_theme_font_size_override("font_size", _font_size)

func _on_mouse_enter():
	self.grab_focus()

func _on_mouse_exit():
	self.release_focus()

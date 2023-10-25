extends HBoxContainer
class_name AttackContainer
@onready var button_container = $ButtonPanelContainer/ButtonContainer
@onready var label = $TextPanelContainer/MarginContainer/ReferenceRect/Text

var _selected_button : int = -1
var buttons: Array[Node]
var _init_buttons

enum Select {NEXT, PREV}

signal button_selected(i: int)

func init(buttons):
	_init_buttons = buttons

func _ready():
	for button in _init_buttons:
		button_container.add_child(button)
	_init_children()
	
func _init_children():
	buttons = button_container.get_children().filter(func(b): return b.get_groups().has("button"))
	
func enable():
	if buttons.size() == 0:
		return
	if _selected_button == -1:
		_selected_button = 0
	button_selected.emit(_selected_button)
	buttons[_selected_button].mouse_entered.emit()
		
func disable():
	if buttons.size() == 0:
		return
	if _selected_button == -1:
		return
	buttons[_selected_button].mouse_exited.emit()
	
func select_next_button(select_type: Select):
	if buttons == null:
		_init_children()
	var old_selected_button = _selected_button
	
	var modifier: int = 1 if select_type == Select.NEXT else -1
	
	_selected_button += modifier
	if _selected_button >= buttons.size():
		_selected_button = 0
	if _selected_button < 0:
		_selected_button = buttons.size() - 1
	var button: Button = buttons[_selected_button] as Button
	button._on_mouse_enter()
	button_selected.emit(_selected_button)
	if old_selected_button != -1:
		button = buttons[old_selected_button]
		button._on_mouse_exit()

func selected_button():
	return buttons[_selected_button]

func fit_container():
	var pos = self.position
	var size = self.size
	var vp = get_viewport().get_visible_rect()
	if vp.end.x < (pos.x + size.x):
		var new_x = vp.end.x - size.x
		pos.x = new_x
	if vp.end.y < (pos.y + size.y):
		var new_y = vp.end.y - size.y - 20
		pos.y = new_y
	if pos != self.position:
		self.position = pos

extends VBoxContainer

var selected_button : int = -1
var buttons: Array[Node]

func _ready():
	_init_children.call_deferred()
	EventBus.select_next_button_pressed.connect(_select_next_button)
	
func _init_children():
	buttons = get_tree().get_nodes_in_group("button")
		
func _select_next_button():
	if buttons == null:
		_init_children()
	var old_selected_button = selected_button
	selected_button += 1
	if selected_button >= buttons.size():
		selected_button = 0
	var button: Button = buttons[selected_button] as Button
	button.mouse_entered.emit()
	if old_selected_button != -1:
		button = buttons[old_selected_button]
		button.mouse_exited.emit()

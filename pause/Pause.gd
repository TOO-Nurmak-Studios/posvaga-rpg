class_name Pause

extends CanvasLayer


@onready var rect = $ColorRect
@onready var pause_button = $PauseButton


var credits_shown: bool


func _ready():
	EventBus.pause_start.connect(start)
	EventBus.credits_hide.connect(hide_credits)
	rect.hide()


func _process(delta):
	pass


func _on_credits_button_pressed():
	show_credits()


func _on_back_button_pressed():
	finish()


func start():
	pause_button.hide()
	rect.show()


func finish():
	rect.hide()
	pause_button.show()
	EventBus.pause_finish.emit()


func show_credits():
	EventBus.credits_show.emit()
	credits_shown = true


func hide_credits():
	credits_shown = false


func _on_pause_button_pressed():
	start()
	

class_name Credits

extends CanvasLayer


func _ready():
	EventBus.credits_show.connect(show)
	hide()


func _on_back_button_pressed():
	EventBus.credits_hide.emit()
	hide()

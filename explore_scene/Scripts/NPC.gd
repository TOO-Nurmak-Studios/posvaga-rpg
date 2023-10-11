extends CharacterBody2D

func interact():
	EventBus.dialog_start.emit(null) #todo: dialog data

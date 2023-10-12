extends CharacterBody2D

var ink_dialog = preload("res://dialog_scene/ink/test.ink.json")

func interact():
	EventBus.dialog_start.emit(ink_dialog, false) #todo: dialog data

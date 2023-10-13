extends CharacterBody2D

var test_dialog = DialogData.new(
	preload("res://dialog_scene/ink/test.ink.json"), false, 
	["test_dialog_visited"])

func interact():
	EventBus.dialog_start.emit(test_dialog) 

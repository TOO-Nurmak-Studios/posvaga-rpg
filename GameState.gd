extends Node

var vars: Dictionary = {}

var curCharacter
var irlCharacter
var simCharacter

func set_var(name, value):
	vars[name] = value
	EventBus.game_state_changed.emit()

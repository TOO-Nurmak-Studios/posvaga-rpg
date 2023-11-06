extends Node

const LAB_HAS_BOOK = "lab_has_book"

var vars: Dictionary = {}

var curParty: PartyState
var irlParty: PartyState
var simParty: PartyState

func set_var(name, value):
	vars[name] = value
	EventBus.game_state_changed.emit()


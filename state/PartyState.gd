class_name PartyState
extends Node

var key: String

var partyLeader: CharacterState
var partyMemberOne: CharacterState #todo
var partyMemberTwo: CharacterState #todo

var inventory: Inventory

func _init(_key: String,
		_partyLeader: CharacterState, 
		_partyMemberOne: CharacterState,
		_partyMemberTwo: CharacterState, 
		_inventory: Inventory):
	
	key = _key
	partyLeader = _partyLeader
	partyMemberOne = _partyMemberOne
	partyMemberTwo = _partyMemberTwo
	inventory = _inventory

class_name CharacterState
extends Node

var hp: int
var maxHp: int
var attacks: Array[Attack]
var stats #todo
var armour #todo
var weapon #todo

func _init(_hp: int, _maxHp: int, _attacks: Array[Attack], _stats, _armour, _weapon):
	hp = _hp
	maxHp = _maxHp
	attacks = _attacks
	stats = _stats
	armour = _armour
	weapon = _weapon

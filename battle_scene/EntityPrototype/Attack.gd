class_name Attack
extends Node


enum AttackType {SINGLE, MULTIPLE}

@export var attack_type: AttackType
@export var attack_name: String
@export var attack_tooltip: String
@export var attack_postmessage: String

func attack(attacker: AbstractCharacter, attacked, gunpoint: Marker2D = null):
	match attack_type:
		AttackType.SINGLE:
			_attack_single(attacker, attacked, gunpoint)
			return
		AttackType.MULTIPLE:
			_attack_multiple(attacker, attacked, gunpoint)
			return
	pass

func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	pass
	
func _attack_multiple(attacker: AbstractCharacter, chars: Array[AbstractCharacter], gunpoint: Marker2D):
	pass

class_name Attack
extends Node


enum AttackType {SINGLE, MULTIPLE}

@export var attack_type: AttackType
@export var attack_name: String

func attack(enemy_to_attack, gunpoint: Marker2D = null):
	match attack_type:
		AttackType.SINGLE:
			_attack_single(enemy_to_attack as Enemy, gunpoint)
			return
		AttackType.MULTIPLE:
			_attack_multiple(enemy_to_attack as Array[Enemy], gunpoint)
			return
	pass

func _attack_single(char: Enemy, gunpoint: Marker2D):
	pass
	
func _attack_multiple(chars: Array[Enemy], gunpoint: Marker2D):
	pass

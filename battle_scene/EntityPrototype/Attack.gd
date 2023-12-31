class_name Attack
extends Node

enum AttackType {SINGLE, MULTIPLE, ON_SELF, ON_ALLY, INVENTORY_OPEN}

@export var attack_type: AttackType
@export var attack_name: String
@export var attack_description: String
@export var attack_tooltip: String
@export var attack_postmessage: String
@export var cooldown: int

var _cooldown: int

signal cooldown_update(cooldown: int)
signal cooldown_end()

func attack(attacker: AbstractCharacter, attacked, gunpoint: Marker2D = null):
	match attack_type:
		AttackType.SINGLE:
			await _attack_single(attacker, attacked, gunpoint)
			return
		AttackType.ON_SELF:
			await _attack_single(attacker, attacked, gunpoint)
			return
		AttackType.ON_ALLY:
			await _attack_single(attacker, attacked, gunpoint)
			return
		AttackType.MULTIPLE:
			await _attack_multiple(attacker, attacked, gunpoint)
			return
		AttackType.INVENTORY_OPEN:
			return

func _attack_single(_attacker: AbstractCharacter, _char: AbstractCharacter, _gunpoint: Marker2D):
	pass
	
func _attack_multiple(_attacker: AbstractCharacter, _chars: Array[AbstractCharacter], _gunpoint: Marker2D):
	pass

func _get_melee_position(attacker: AbstractCharacter, char: AbstractCharacter, how_close: float = 0.9):
	return attacker.position * (1 - how_close) + char.position * how_close

func decrement_cooldown():
	if _cooldown == 0:
		return
		
	_cooldown -= 1
	if _cooldown == 0:
		cooldown_end.emit()
	else:
		cooldown_update.emit(_cooldown)
		
func start_cooldown():
	_cooldown = cooldown
	cooldown_update.emit(cooldown)

func wait(sec: float):
	await get_tree().create_timer(sec).timeout

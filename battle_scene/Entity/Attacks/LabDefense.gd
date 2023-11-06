class_name LabDefense
extends Attack

@export var chant_length: float = 1
@export var atk_cooldown: int = 2

func _init():
	attack_name = "Защита"
	attack_type = Attack.AttackType.ON_SELF
	attack_tooltip = "Нажмите Enter для применения, вернуться к выбору атаки - Esc."
	attack_description = "Помолиться для уменьшения входящего урона."
	attack_postmessage = str("%s защищается от %s.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, _char: AbstractCharacter, gunpoint: Marker2D):
	await attacker.defence()
	
	EventBus.emit_attack_ended(attacker, [_char] as Array[AbstractCharacter], self)


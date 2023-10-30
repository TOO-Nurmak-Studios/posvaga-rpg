class_name LabDefense
extends Attack

@export var chant_length: float = 1
@export var atk_cooldown: int = 2

func _init():
	attack_name = "Защита"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Нажмите Enter для применения."
	attack_description = "Помолиться Аллаху для уменьшения входящего урона."
	attack_postmessage = str("%s защищается от %s.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, _char: AbstractCharacter, gunpoint: Marker2D):
	attacker.sprite.play("shield")
	await attacker.sprite.animation_finished
	
	attacker.health.add_damage_reduction(0.5)
	#end of attack
	attacker.sprite.play("idle")
	EventBus.emit_attack_ended(attacker, [_char] as Array[AbstractCharacter], self)


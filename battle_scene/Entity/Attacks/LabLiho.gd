class_name LabLiho
extends ItemAttack

@export var run_time_length: float = 1
@export var damage: float = 10

func _init():
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Выбор врага: вверх/вниз, удар: Enter, вернуться к выбору атаки - Esc/влево."
	attack_postmessage = str("{attacker} взрывает {attacked}, нанося {damage} урона.")
	cooldown = 1
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	var animation_name = "kick"
	var start_position = attacker.position
	var char_array = [char]
	var position_to_attack = super._get_melee_position(attacker, char, 0.8)
	attacker.walk()
	var tween: Tween = attacker.create_tween()
	
	# move to position
	tween.tween_property(attacker, "position", position_to_attack, run_time_length)
	tween.tween_interval(0.2)
	
	# attack
	tween.tween_callback(_play_kick_animation.bind(attacker, char, animation_name))
	tween.tween_interval(attacker.get_animation_duration(animation_name) + 0.25)
	
	#move back
	tween.tween_property(attacker, "position", start_position, run_time_length)
	
	#end of attack
	tween.tween_callback(_on_after_attack.bind(attacker, char))

func _play_kick_animation(attacker: AbstractCharacter, char: AbstractCharacter, animation_name: String):
	attacker.stop_walk()
	await attacker.kick()
	char.take_damage(damage, attacker)
	await wait(0.25)
	attacker.walk()

func _on_after_attack(attacker: AbstractCharacter, char: AbstractCharacter):
	attacker.sprite.play("idle")
	attacker.stop_walk()
	EventBus.emit_attack_ended(attacker, [char] as Array[AbstractCharacter], self)

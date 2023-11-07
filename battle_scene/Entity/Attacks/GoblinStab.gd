class_name GoblinStab
extends Attack

const post_attack_wait = 0.5

@export var run_time_length: float = 1
@export var damage: float = 10
@export var atk_cooldown: int = 1

@onready var rand = RandomNumberGenerator.new()

func _init():
	attack_name = "Goblin Stab"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = ""
	attack_description = ""
	attack_postmessage = str("{attacker} бьет ножом {attacked}, нанося {damage} урона.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	var start_position = attacker.position
	var char_array = [char]
	var position_to_attack = super._get_melee_position(attacker, char, 0.8)
	attacker.walk()
	var tween: Tween = attacker.create_tween()
	
	# move to position
	tween.tween_property(attacker, "position", position_to_attack, run_time_length)
	tween.tween_interval(0.2)
	
	# attack
	tween.tween_callback(_play_animation.bind(attacker, char))
	tween.tween_interval(attacker.get_animation_duration("stab") + post_attack_wait)
	
	#move back
	tween.tween_property(attacker, "position", start_position, run_time_length)
	
	#end of attack
	tween.tween_callback(_on_after_attack.bind(attacker, char))

func _play_animation(attacker: AbstractCharacter, char: AbstractCharacter):
	attacker.stop_walk()
	await attacker.stab()
	char.take_damage(damage, attacker)
	await wait(post_attack_wait)
	attacker.walk()

func _on_after_attack(attacker: AbstractCharacter, char: AbstractCharacter):
	attacker.sprite.play("idle")
	attacker.stop_walk()
	EventBus.emit_attack_ended(attacker, [char] as Array[AbstractCharacter], self)

class_name CockroachBite
extends Attack

@export var run_time_length: float = 1
@export var damage: float = 3
@export var atk_cooldown: int = 2
var current_callable_on_finish: Callable

@onready var rand = RandomNumberGenerator.new()

func _init():
	attack_name = "Cockroach Bite"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to attack."
	attack_description = "Common cockroach bite"
	attack_postmessage = str("%s bites %s for ", damage, " damage.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	var animation_name	
	if attacker.sprite.sprite_frames.has_animation("bite_funny"):
		var rand_int = randi_range(0, 3)
		if rand_int != 0:
			animation_name = "bite_normal"
		else:
			animation_name = "bite_funny"
	else:
		animation_name = "bite_normal"
	var start_position = attacker.position
	var char_array = [char]
	var position_to_attack = super._get_melee_position(attacker, char)
	attacker.sprite.play("walk")
	var tween: Tween = attacker.create_tween()
	
	# move to position
	tween.tween_property(attacker, "position", position_to_attack, run_time_length)
	tween.tween_interval(0.2)
	
	# attack
	tween.tween_callback(_play_bite_animation.bind(attacker, char, animation_name))
	tween.tween_interval(attacker.get_animation_duration(animation_name))
	
	#move back
	tween.tween_property(attacker, "position", start_position, run_time_length)
	
	#end of attack
	tween.tween_callback(_on_after_attack.bind(attacker, char))

func _play_bite_animation(attacker: AbstractCharacter, char: AbstractCharacter, animation_name: String):
	current_callable_on_finish = _on_after_bite.bind(attacker, char)
	attacker.sprite.play(animation_name)
	attacker.sprite.animation_finished.connect(current_callable_on_finish)
	
func _on_after_bite(attacker: AbstractCharacter, char: AbstractCharacter):
	attacker.sprite.play("walk")
	await char.take_damage(damage, attacker)
	attacker.sprite.animation_finished.disconnect(current_callable_on_finish)

func _on_after_attack(attacker: AbstractCharacter, char: AbstractCharacter):
	attacker.sprite.play("idle")
	EventBus.emit_attack_ended(attacker, [char] as Array[AbstractCharacter], self)

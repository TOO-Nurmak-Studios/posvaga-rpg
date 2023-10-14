class_name PointBlankShot
extends Attack

@export var run_time_length: float = 1
@export var bullet_damage: float = 25
@export var bullet_recoil_multiplier = 1.2
@export var distance_part = 0.8
@export var atk_cooldown = 2
var current_callable_on_finish: Callable

func _init():
	attack_name = "Point-Blank Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to attack."
	attack_postmessage = str("%s shoots %s for ", bullet_damage, " damage.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	var start_position = attacker.position
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(attacker, "position", super._get_melee_position(attacker, char, distance_part), run_time_length)
	tween.tween_interval(attacker.get_animation_duration("shoot"))
	tween.tween_callback(
		func(): 
			current_callable_on_finish = func():
				attacker.sprite.play("idle")
				char.take_damage(bullet_damage, attacker, bullet_recoil_multiplier)
				attacker.sprite.animation_finished.disconnect(current_callable_on_finish)
			attacker.sprite.stop()
			attacker.sprite.play("shoot")
			attacker.sprite.animation_finished.connect(current_callable_on_finish)
	)
	tween.tween_interval(0.5)
	tween.tween_property(attacker, "position", start_position, run_time_length)
	tween.tween_callback(func(): EventBus.emit_attack_ended(attacker, [char], self))
	pass



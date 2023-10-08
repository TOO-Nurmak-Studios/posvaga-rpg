class_name PointBlankShot
extends Attack

@export var run_time_length: float = 1
@export var bullet_damage: float = 25
var bullet_scene: Resource = preload("res://battle_scene/Entity/Bullet.tscn")
var current_callable_on_finish: Callable

func _init():
	attack_name = "Point-Blank Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to attack."
	attack_postmessage = str("%s shoots %s for ", bullet_damage, " damage.")
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	var start_position = attacker.position
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(attacker, "position", char.position * 0.8, run_time_length)
	tween.tween_callback(
		func(): 
			char.take_damage(bullet_damage)
	)
	tween.tween_property(attacker, "position", start_position, run_time_length)
	tween.tween_callback(func(): EventBus.emit_attack_landed(attacker, [char], self))
	pass



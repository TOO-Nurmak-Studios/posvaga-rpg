class_name SingleShotAttack
extends Attack

@export var bullet_flight_length: float = 0.2
@export var bullet_damage: float = 10
var bullet_scene: Resource = preload("res://battle_scene/Entity/Bullet.tscn")
var current_callable_on_finish: Callable

func _init():
	attack_name = "Single Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to shoot."
	attack_postmessage = str("%s shoots %s for ", bullet_damage, " damage.")
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		pass
		
	var projectile = bullet_scene.instantiate();
	if projectile == null:
		pass
	projectile.position = gunpoint.global_position
	projectile.damage = bullet_damage
	projectile.target = char.position
	add_sibling(projectile)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(projectile, "position", projectile.target, bullet_flight_length)
	tween.tween_callback(
		func(): 
			char.take_damage(projectile.damage)
			EventBus.emit_attack_landed(attacker, [char], self)
			projectile.queue_free()
	)
	pass



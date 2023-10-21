class_name SingleShotAttack
extends Attack

@export var bullet_flight_length: float = 0.2
@export var bullet_damage: float = 10
@export var atk_cooldown = 1
var bullet_scene: Resource = preload("res://battle_scene/Entity/Bullet.tscn")
var current_callable_on_finish: Callable

func _init():
	attack_name = "Single Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to shoot."
	attack_postmessage = str("%s shoots %s for ", bullet_damage, " damage.")
	attack_description = "Just one shot."
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	attacker.sprite.play("shoot")
	await attacker.sprite.animation_finished
	attacker.sprite.play("idle")
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		pass
		
	var projectile = bullet_scene.instantiate();
	if projectile == null:
		pass
	projectile.position = gunpoint.global_position
	projectile.target = char.position
	add_sibling(projectile)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(projectile, "position", projectile.target, bullet_flight_length)
	tween.tween_callback(
		func(): 
		
			projectile.queue_free()
			await char.take_damage(bullet_damage, attacker)
			EventBus.emit_attack_ended(attacker, [char], self)
	)
	pass



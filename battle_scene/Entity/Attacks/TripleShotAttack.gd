class_name TripleShotAttack
extends Attack

@export var bullet_flight_length: float = 0.5
@export var bullet_damage: float = 20
@export var bullet_scale = Vector2(0.5, 0.5)
@export var atk_cooldown = 3
var bullet_positions = [Vector2.ZERO, Vector2(8, 8), Vector2(8, -8)]

var bullet_scene: Resource = preload("res://battle_scene/Entity/Bullet.tscn")

var _projectiles_hit_target: int = 0

func _init():
	attack_name = "Shotgun Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to shoot."
	attack_postmessage = str("%s shoots %s with shotgun for ", bullet_damage * bullet_positions.size(), " damage.")
	attack_description = "Shoot three bullets at the same time."
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	attacker.sprite.play("shoot_shotgun")
	await attacker.sprite.animation_finished
	attacker.sprite.play("idle")
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		pass
			
	var projectiles: Array[Projectile] = []		
	for i in range(bullet_positions.size()):
		var projectile = bullet_scene.instantiate();
		projectile.position = gunpoint.global_position + bullet_positions[i]
		projectile.scale = bullet_scale
		projectile.target = char.position + bullet_positions[i] * 2
		add_sibling(projectile)
		projectiles.append(projectile)
	
	for p in projectiles:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(p, "position", p.target, bullet_flight_length)
		tween.tween_callback(
			func(): 
				p.queue_free()
				await char.take_damage(bullet_damage, attacker, 1.5)
				_projectiles_hit_target += 1
				if _projectiles_hit_target == 3:
					EventBus.emit_attack_ended(attacker, [char], self)
					_projectiles_hit_target = 0
		)
	pass



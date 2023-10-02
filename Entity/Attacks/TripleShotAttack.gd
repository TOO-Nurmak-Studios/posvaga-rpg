class_name TripleShotAttack
extends Attack

@export var bullet_flight_length: float = 1
@export var bullet_damage: float = 5
@export var bullet_scale = Vector2(0.15, 0.15)

var bullet_scene: Resource = preload("res://Entity/Bullet.tscn")

var _projectiles_hit_target: int = 0

func _init():
	attack_name = "Shotgun Shot"
	attack_type = Attack.AttackType.SINGLE
	
func _attack_single(char: Enemy, gunpoint: Marker2D):
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		pass
			
	var projectiles: Array[Projectile] = []		
	var projectile = bullet_scene.instantiate();
	projectile.position = gunpoint.global_position
	projectile.scale = bullet_scale
	projectile.damage = bullet_damage
	projectile.target = char.position
	add_sibling(projectile)
	projectiles.append(projectile)
			
	projectile = bullet_scene.instantiate();
	projectile.position = gunpoint.global_position + Vector2(20, 20)
	projectile.damage = bullet_damage
	projectile.target = char.position + Vector2(40, 40)
	projectile.scale = bullet_scale
	add_sibling(projectile)
	projectiles.append(projectile)
	
	projectile = bullet_scene.instantiate();
	projectile.position = gunpoint.global_position + Vector2(20, -20)
	projectile.damage = bullet_damage
	projectile.target = char.position + Vector2(40, -40)
	projectile.scale = bullet_scale
	add_sibling(projectile)
	projectiles.append(projectile)
	
	for p in projectiles:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(p, "position", p.target, bullet_flight_length)
		tween.tween_callback(
			func(): 
				char.take_damage(p.damage)
				_projectiles_hit_target += 1
				if _projectiles_hit_target == 3:
					EventBus.emit_player_attack_landed(self)
					_projectiles_hit_target = 0
				p.queue_free()
		)
	pass



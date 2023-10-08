class_name TripleShotAttack
extends Attack

@export var bullet_flight_length: float = 0.5
@export var bullet_damage: float = 20
@export var bullet_scale = Vector2(0.5, 0.5)
var bullet_positions = [Vector2.ZERO, Vector2(8, 8), Vector2(8, -8)]

var bullet_scene: Resource = preload("res://battle_scene/Entity/Bullet.tscn")

var _projectiles_hit_target: int = 0

func _init():
	attack_name = "Shotgun Shot"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to shoot."
	attack_postmessage = str("%s shoots with shotgun %s for ", bullet_damage * bullet_positions.size(), " damage.")
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		pass
			
	var projectiles: Array[Projectile] = []		
	for i in range(bullet_positions.size()):
		var projectile = bullet_scene.instantiate();
		projectile.position = gunpoint.global_position + bullet_positions[i]
		projectile.scale = bullet_scale
		projectile.damage = bullet_damage
		projectile.target = char.position + bullet_positions[i] * 2
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
					EventBus.emit_attack_landed(attacker, [char], self)
					_projectiles_hit_target = 0
				p.queue_free()
		)
	pass



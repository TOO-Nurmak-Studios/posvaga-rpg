class_name SingleShotAttack
extends Attack

@export var bullet_speed: float = 0.5
@export var bullet_damage: float = 10
var bullet_scene: Resource = preload("res://Entity/Bullet.tscn")
var current_callable_on_finish: Callable

func _init():
	attack_name = "Single Shot"
	attack_type = Attack.AttackType.SINGLE
	
func _attack_single(char: Enemy, gunpoint: Marker2D):
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
	tween.tween_property(projectile, "position", projectile.target, bullet_speed)
	tween.tween_callback(
		func(): 
			char.take_damage(projectile.damage)
			EventBus.emit_player_attack_landed(self)
			projectile.queue_free()
	)
	pass



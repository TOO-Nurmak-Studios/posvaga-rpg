class_name TestPlayer
extends MovableArea2D

@onready var crosshair: Marker2D = $Crosshair
@onready var health: HealthNode = $HealthNode as HealthNode
@onready var sprite: AnimatedSprite2D = $Sprite
@export var bullet_speed: float = 500
@export var bullet_damage: float = 10

signal death(dead_char: TestCharacter)

var bullet_scene: Resource = preload("res://Entity/Bullet.tscn")
var current_callable_on_finish: Callable

func _ready():
	health.zero_health.connect(die)
	pass
	
func shoot(char: TestCharacter):
	sprite.play("shoot")
	current_callable_on_finish = func(): send_bullet(char)
	sprite.animation_finished.connect(current_callable_on_finish)
	
func send_bullet(char: TestCharacter):
	sprite.set_frame_and_progress(0, 0)
	sprite.animation_finished.disconnect(current_callable_on_finish)
	if crosshair == null:
		printerr("Trying to shoot without a gunpoint")
		pass
		
	var projectile = generate_projectile();
	if projectile == null:
		pass
		
	var position = crosshair.global_position
	projectile.position = position
	projectile.damage = bullet_damage
	#var velocity_vector = (point - crosshair.global_position).normalized() * bullet_speed;
	add_sibling(projectile)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(projectile, "position", char.position, 0.5)
	tween.tween_callback(
		func(): 
			char.take_damage(projectile.damage)
			EventBus.emit_player_projectile_landed()
			projectile.queue_free()
	)
	pass

func generate_projectile() -> Projectile:
	return bullet_scene.instantiate()

func take_damage(damage: int):
	health.remove_health(damage)
	
func die():
	death.emit(self)
	queue_free()

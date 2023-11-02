class_name LabThrowBook
extends Attack

@export var book_flight_length: float = 1
@export var book_damage: float = 20
var book_scene: Resource = preload("res://battle_scene/Entity/Book.tscn")
var current_callable_on_finish: Callable

func _init():
	attack_name = "Бросок книги"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Выбор врага: стрелки, удар: Enter."
	attack_postmessage = str("%s бросает книгу в %s, нанося ", book_damage, " урона.")
	attack_description = "Кинуть вашу любимую часть Зорича в лицо врагу."
	cooldown = 3
	
func _attack_single(attacker: AbstractCharacter, char: AbstractCharacter, gunpoint: Marker2D):
	await attacker.throw_book()
	
	if gunpoint == null:
		printerr("Trying to shoot without a gunpoint")
		return
		
	var projectile = book_scene.instantiate();
	projectile.position = gunpoint.global_position
	projectile.target = char.position
	add_sibling(projectile)
	
	var p_tween: Tween = get_tree().create_tween()
	p_tween.set_loops()
	p_tween.tween_property(projectile, "rotation", 360, 0.1)
	p_tween.tween_property(projectile, "rotation", -360, 0)
	p_tween.tween_property(projectile, "rotation", 0, 0.1)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(projectile, "position", projectile.target, book_flight_length)
	tween.tween_callback(_on_attack_land.bind(projectile, attacker, char))

func _on_attack_land(projectile, attacker: AbstractCharacter, char: AbstractCharacter):
	projectile.queue_free()
	attacker.book_impact_sound()
	await char.take_damage(book_damage, attacker)
	EventBus.emit_attack_ended(attacker, [char], self)


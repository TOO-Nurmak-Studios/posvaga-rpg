class_name AbstractCharacter
extends Node2D

@onready var health: HealthNode = $HealthNode as HealthNode

@export var char_name: String = "Unnamed Character"
@export var initiative: int

@export var attacks: Array[Attack]

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var gunpoint: Marker2D = $Crosshair

var in_flight_attack: Callable
var is_attack_in_flight = false
var is_dead = false

enum CharacterType {UNKNOWN, PLAYER, ENEMY}

signal death(dead_char: AbstractCharacter)

func _ready():
	initiative = 10 + RandomNumberGenerator.new().randi_range(-5, 5)
	health.zero_health.connect(mark_dead)
	for attack in attacks:
		add_sibling.call_deferred(attack)

func attack(index: int, enemy_to_attack):
	#sprite.play(attack_animations[index])
	is_attack_in_flight = true
	#await sprite.animation_finished
	#sprite.animation = "idle"
	await attacks[index].attack(self, enemy_to_attack, gunpoint)
	is_attack_in_flight = false

func get_animation_duration(anim_name: StringName):
	var frames: int = sprite.sprite_frames.get_frame_count(anim_name)
	var duration = sprite.sprite_frames.get_animation_speed(anim_name)
	return frames / duration

func select():
	sprite.animation = "idle_selected"

func unselect():
	if !is_attack_in_flight:
		sprite.play("idle")

func mark_dead():
	is_dead = true

func take_damage(damage: int, source_nullable: AbstractCharacter = null, recoil_modifier: int = 1):
	if source_nullable != null:
		# all constants here are absolutely random and were chosen
		# using method "I think this it looks fine with this one"
		var source_pos = source_nullable.position
		var self_pos = position
		var dmg_vec = source_pos.direction_to(self_pos) * 16 * recoil_modifier
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CIRC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", self_pos + dmg_vec, 0.1 * recoil_modifier)
		tween.tween_property(self, "position", self_pos, 0.1 * recoil_modifier)
		await tween.finished
	health.remove_health(damage)
	
func die():
	death.emit(self)
	if sprite.sprite_frames.has_animation("death"):
		sprite.stop()
		sprite.play("death")	
		await sprite.animation_finished
	queue_free()

func get_type() -> CharacterType:
	return CharacterType.UNKNOWN 

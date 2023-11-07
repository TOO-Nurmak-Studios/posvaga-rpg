class_name AbstractCharacter
extends Node2D

@onready var health: HealthNode = $HealthNode as HealthNode

@export var char_name: String = "Unnamed Character"
@export var attacks: Array[Attack]
@export var death_sound: AudioStream
@export var select_border_width = 2

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var gunpoint: Marker2D = $Crosshair
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var attack_audio: AudioStreamPlayer2D = $AttackAudio

var in_flight_attack: Callable
var is_dead = false

enum CharacterType {UNKNOWN, PLAYER, ENEMY}

signal death(dead_char: AbstractCharacter)

func _ready():
	health.zero_health.connect(mark_dead)
	for attack in attacks:
		add_sibling.call_deferred(attack)

func attack(index: int, enemy_to_attack):
	await attacks[index].attack(self, enemy_to_attack, gunpoint)

func get_animation_duration(anim_name: StringName):
	var frames: int = sprite.sprite_frames.get_frame_count(anim_name)
	var duration = sprite.sprite_frames.get_animation_speed(anim_name)
	return frames / duration

func select():
	var sh = self.sprite.material as ShaderMaterial
	sh.set_shader_parameter("width", select_border_width)

func unselect():
	var sh = self.sprite.material as ShaderMaterial
	sh.set_shader_parameter("width", 0)

func mark_dead():
	is_dead = true

func take_damage(damage: int, source_nullable: AbstractCharacter = null, recoil_modifier: int = 1):
	_on_damage_taken(damage, source_nullable)
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
	
func _on_damage_taken(damage: int, source_nullable: AbstractCharacter = null):
	pass
	
func die():
	death.emit(self)
	await play_death_animation()
	queue_free()
	
func _death_animation():
	if !sprite.sprite_frames.has_animation("death"):
		return
	sprite.stop()
	sprite.play("death")
	await sprite.animation_finished
	
func play_death_animation():	
	if death_sound != null:
		attack_audio.stream = death_sound
		attack_audio.play()
	await _death_animation()

func get_type() -> CharacterType:
	return CharacterType.UNKNOWN 

func decrement_attack_cooldown():
	for attack in attacks:
		attack.decrement_cooldown()

func walk():
	sprite.play("walk")
	audio.play()

func stop_walk():
	audio.stop()

func play_attack_audio(stream, delay = 0.0):
	attack_audio.stream = stream
	if delay != 0.0:
		get_tree().create_timer(delay).timeout.connect(func(): attack_audio.play())
	else:
		attack_audio.play()

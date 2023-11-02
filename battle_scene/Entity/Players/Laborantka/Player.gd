class_name Laborantka
extends AbstractCharacter

@export var kick_stream: AudioStream
@export var def_stream: AudioStream
@export var book_stream: AudioStream
@export var book_impact_stream: AudioStream

var shader = preload("res://battle_scene/HUD/Shaders/ShaderDeath.tres")

func _init():
	attacks = [LabKick.new(), LabDefense.new(), LabThrowBook.new()]

func _ready():
	super._ready()
	sprite.play("idle")
	unselect()

func get_type() -> CharacterType:
	return CharacterType.PLAYER 
	
func play_death_animation():
	sprite.material = shader.duplicate()
	var sh_tween = get_tree().create_tween()
	sh_tween.tween_property(sprite.material, "shader_parameter/progress", 1, 2)
	await sh_tween.finished
	
func kick():
	play_attack_audio(kick_stream, 0.45)
	sprite.play("kick")
	await sprite.animation_finished
	sprite.play("idle")

func defence():
	play_attack_audio(def_stream)
	sprite.play("shield")
	await sprite.animation_finished
	sprite.play("idle")
	health.add_damage_reduction(0.5)

func throw_book():
	play_attack_audio(book_stream)
	sprite.play("throw")
	await sprite.animation_finished
	sprite.play("idle")

func book_impact_sound():	
	play_attack_audio(book_impact_stream)

class_name Laborantka
extends AbstractCharacter

@export var kick_stream: AudioStream
@export var def_stream: AudioStream
@export var book_stream: AudioStream
@export var book_impact_stream: AudioStream

var book_attack = LabThrowBook.new()
var has_book = false

var shader = preload("res://battle_scene/HUD/Shaders/ShaderDeath.tres")

func _init():
	attacks = [LabKick.new(), LabDefense.new()]

func _ready():
	super._ready()
	sprite.play("idle")
	unselect()
	_try_add_book()
	if !has_book:
		EventBus.game_vars_changed.connect(_try_add_book)

func _try_add_book():
	if !has_book && GameState.vars.get(GameState.LAB_HAS_BOOK, false) == true:
		attacks.push_back(book_attack)
		add_sibling(book_attack)
		has_book = true
	elif has_book && GameState.vars.get(GameState.LAB_HAS_BOOK, false) == false:
		book_attack.queue_free()
		attacks.erase(book_attack)

func get_type() -> CharacterType:
	return CharacterType.PLAYER 
	
func _death_animation():
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

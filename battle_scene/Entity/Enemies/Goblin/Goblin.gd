class_name Goblin
extends Enemy

@onready var blood_emitter: GPUParticles2D = $BloodEmitter as GPUParticles2D

@export var attack_stream: AudioStream

@export var attack_damage = 20
@export var attack_cooldown = 1

func _init():
	attacks = [GoblinStab.new()]

func _ready():
	super._ready()
	attacks[0].damage = attack_damage
	attacks[0].cooldown = attack_cooldown
	
func stab():
	play_attack_audio(attack_stream)
	sprite.play("stab")
	await sprite.animation_finished
	sprite.play("idle")

func _on_damage_taken(damage: int, source_nullable: AbstractCharacter = null):
	sprite.play("damaged")
	sprite.animation_finished.connect(sprite.play.bind("idle"))
	var source_pos = source_nullable.position
	var self_pos = position
	var dmg_vec = source_pos.direction_to(self_pos) 
	var mat = blood_emitter.process_material as ParticleProcessMaterial
	mat.direction = Vector3(dmg_vec.x, dmg_vec.y, 0) 
	blood_emitter.restart()
	pass

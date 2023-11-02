class_name Cockroach
extends Enemy

@onready var blood_emitter: GPUParticles2D = $BloodEmitter as GPUParticles2D

@export var attack_stream: AudioStream
@export var spawn_stream: AudioStream

func _init():
	attacks = [CockroachChant.new()]

func _ready():
	super._ready()

func bite(animation_name: String):
	play_attack_audio(attack_stream)
	sprite.play(animation_name)
	await sprite.animation_finished
	sprite.play("idle")
	
func play_spawn_effect():
	sprite.play("chant")
	play_attack_audio(spawn_stream, 0.1)
	
func _on_damage_taken(damage: int, source_nullable: AbstractCharacter = null):
	var source_pos = source_nullable.position
	var self_pos = position
	var dmg_vec = source_pos.direction_to(self_pos) 
	var mat = blood_emitter.process_material as ParticleProcessMaterial
	mat.direction = Vector3(dmg_vec.x, dmg_vec.y, 0) 
	blood_emitter.restart()
	pass

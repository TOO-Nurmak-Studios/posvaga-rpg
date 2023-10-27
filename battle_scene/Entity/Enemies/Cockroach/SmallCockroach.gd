class_name SmallCockroach
extends Enemy

@onready var blood_emitter: GPUParticles2D = $BloodEmitter as GPUParticles2D

func _init():
	attacks = [CockroachBite.new()]

func _ready():
	super._ready()
	char_name = "Small Cock Roach"

func _on_damage_taken(damage: int, source_nullable: AbstractCharacter = null):
	var source_pos = source_nullable.position
	var self_pos = position
	var dmg_vec = source_pos.direction_to(self_pos) 
	var mat = blood_emitter.process_material as ParticleProcessMaterial
	mat.direction = Vector3(dmg_vec.x, dmg_vec.y, 0) 
	blood_emitter.restart()
	pass
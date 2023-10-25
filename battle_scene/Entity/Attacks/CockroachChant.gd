class_name CockroachChant
extends Attack

var small_cockroach_scene: PackedScene = preload("res://battle_scene/Entity/Enemies/Cockroach/SmallCockroach.tscn")

@export var chant_length: float = 1
@export var atk_cooldown: int = 1
@export var spawn_distance: int = 4

@onready var rand = RandomNumberGenerator.new()

func _init():
	attack_name = "Cockroach Chany"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to attack."
	attack_description = "Common cockroach bite"
	attack_postmessage = str("%s spawns a new small cockroach to scare %s.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, _char: AbstractCharacter, gunpoint: Marker2D):
	var animation_name	= "chant"
	var start_position = attacker.position
	attacker.sprite.play("chant")
	
	var new_cockroach = small_cockroach_scene.instantiate() as SmallCockroach
	new_cockroach.scale = Vector2(0.5, 0.5)
	#_calculate_position(attacker, new_cockroach)
	
	new_cockroach.ready.connect(_calculate_position.bind(attacker, new_cockroach))
	add_sibling(new_cockroach)
	await get_tree().create_timer(chant_length).timeout
	#end of attack
	attacker.sprite.play("idle")
	EventBus.emit_attack_ended(attacker, [_char] as Array[AbstractCharacter], self)


func _calculate_position(attacker: Cockroach, small_cockroach: SmallCockroach):
	var spawner_position = attacker.position
	var attacker_size = attacker.sprite.sprite_frames.get_frame_texture("idle", 0).get_size() * attacker.scale
	var new_spawn_size = small_cockroach.sprite.sprite_frames.get_frame_texture("idle", 0).get_size() * small_cockroach.scale
	var spawn_point = attacker_size * 0.5 + new_spawn_size * 0.5 + Vector2(spawn_distance, spawn_distance)
	print("Calculated: attacker_size is ", attacker_size, " new spawn size is ", new_spawn_size)
	while true:
		var angle = rand.randf_range(1.57, 4.71)
		var new_spawn = spawn_point.rotated(angle)
		if !get_viewport().get_visible_rect().has_point(spawner_position + new_spawn):
			continue
		small_cockroach.position = spawner_position + new_spawn
		print("position is ", small_cockroach.position)
		break

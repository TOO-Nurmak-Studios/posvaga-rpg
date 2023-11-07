class_name CockroachChant
extends Attack

var small_cockroach_scene: PackedScene = preload("res://battle_scene/Entity/Enemies/Cockroach/SmallCockroach.tscn")

@export var chant_length: float = 1
@export var atk_cooldown: int = 2

@onready var rand = BetterRandNumGen.new()

func _init():
	attack_name = "Cockroach Chant"
	attack_type = Attack.AttackType.SINGLE
	attack_tooltip = "Select enemy with arrows, press enter to attack."
	attack_description = "Common cockroach bite"
	attack_postmessage = str("{attacker} призывает маленького кокроча.")
	self.cooldown = atk_cooldown
	
func _attack_single(attacker: AbstractCharacter, _char: AbstractCharacter, gunpoint: Marker2D):
	var animation_name	= "chant"
	var start_position = attacker.position
	
	attacker.play_spawn_effect()
	
	var new_cockroach = small_cockroach_scene.instantiate() as SmallCockroach
	
	new_cockroach.ready.connect(_calculate_position.bind(attacker, new_cockroach))
	add_sibling(new_cockroach)
	await wait(chant_length)
	#end of attack
	attacker.sprite.play("idle")
	EventBus.emit_attack_ended(attacker, [_char] as Array[AbstractCharacter], self)


func _calculate_position(attacker: Cockroach, small_cockroach: SmallCockroach):
	var spawner_position = attacker.position
	var attacker_size = attacker.sprite.sprite_frames.get_frame_texture("idle", 0).get_size() * attacker.scale
	var new_spawn_size = small_cockroach.sprite.sprite_frames.get_frame_texture("idle", 0).get_size() * small_cockroach.scale
	var spawn_point = attacker_size * 0.5 + new_spawn_size * 0.5 + Vector2(
		rand.randi_range(10, 150), 0)
	spawn_point.y = 0
	while true:
		var deg = 160 + 3 * rand.randi_range(0, 10) # 160 - 190
		var angle = deg_to_rad(deg)
		var new_spawn = spawn_point.rotated(angle)
		if !get_viewport().get_visible_rect().has_point(spawner_position + new_spawn):
			continue
		small_cockroach.position = spawner_position + new_spawn
		break

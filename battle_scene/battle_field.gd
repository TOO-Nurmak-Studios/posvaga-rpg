extends CanvasLayer
class_name BattleField

var battle_background: BattleBackground
var _players
var _enemies
var _dialogue

var shader = preload("res://battle_scene/HUD/Shaders/ShaderBlur.tres")

# battle start constants
const start_time = 1
const start_scale = 0.5

@onready var select_manager: SelectManager = $SubViewport/SelectManager as SelectManager
@onready var hud_manager: HUDManager = $SubViewport/HUDManager as HUDManager
@onready var swp: SubViewport = $SubViewport as SubViewport
@onready var swp_sprite: Sprite2D = $ViewportSprite as Sprite2D
@onready var battle_manager: BattleManager = $SubViewport/BattleManager as BattleManager
@onready var dialogue_manager: BattleDialogueManager = $SubViewport/BattleDialogueManager as BattleDialogueManager

func init(back: BattleBackground, players, enemies, dialogue: Dictionary):
	battle_background = back
	_players = players
	_enemies = enemies
	_dialogue = dialogue
	
func _ready():
	swp.add_child(battle_background)
	
	var player_marker_index = 0	
	for player in _players:
		var spawn_pos = battle_background.player_markers[player_marker_index].position
		player.position = spawn_pos
		swp.add_child(player)
		player_marker_index += 1
	
	var enemy_marker_index = 0	
	for enemy in _enemies:
		var spawn_pos = battle_background.enemy_markers[enemy_marker_index].position
		enemy.position = spawn_pos
		swp.add_child(enemy)
		enemy_marker_index += 1
	
	select_manager.start()
	battle_manager.start()
	hud_manager.start()
	dialogue_manager.init(_dialogue)
	
	play_battle_start_effect()
	EventBus.battle_scene_fade_away.connect(play_battle_end_effect)
	
func play_battle_start_effect():
	var image_before_battle = get_viewport().get_texture().get_image()
	var sprite_before_battle = Sprite2D.new() as Sprite2D
	sprite_before_battle.position = get_viewport().get_visible_rect().size / 2
	sprite_before_battle.texture = ImageTexture.create_from_image(image_before_battle)
	sprite_before_battle.z_index = 5
	add_child(sprite_before_battle)
	await RenderingServer.frame_post_draw
	
	var image = swp.get_texture().get_image()
	var sprite = Sprite2D.new() as Sprite2D
	sprite.position = get_viewport().get_visible_rect().size / 2
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.material = shader
	sprite.scale = Vector2(start_scale, start_scale)
	sprite.z_index = 6
	
	var sh_tween = get_tree().create_tween()
	sh_tween.tween_property(sprite.material, "shader_parameter/dir", Vector2(0, 0), start_time)
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1, 1), start_time)
	tween.tween_callback(sprite.queue_free)
	tween.tween_callback(sprite_before_battle.queue_free)
	tween.tween_interval(1.0)
	tween.tween_callback(launch_battle)
	add_child(sprite)

func launch_battle():
	hud_manager.enable_player_movement()
	battle_manager.start_next_round()
	EventBus.emit_battle_scene_start()

func play_battle_end_effect(result):
	await RenderingServer.frame_post_draw
	var sprite_end_battle = Sprite2D.new() as Sprite2D
	sprite_end_battle.position = get_viewport().get_visible_rect().size / 2
	sprite_end_battle.texture = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	sprite_end_battle.z_index = 5
	sprite_end_battle.material = shader
	add_child(sprite_end_battle)
	swp_sprite.hide()
	
	var sh_tween = get_tree().create_tween()
	sh_tween.tween_interval(start_time)
	sh_tween.tween_property(sprite_end_battle.material, "shader_parameter/dir", Vector2(-0.25, -0.25), start_time)
	
	var tween = get_tree().create_tween()
	tween.tween_interval(start_time)
	tween.tween_property(sprite_end_battle, "scale", Vector2(start_scale, start_scale), start_time)
	tween.tween_callback(sprite_end_battle.queue_free)
	tween.tween_callback(EventBus.emit_battle_scene_end.bind(result))
	#tween.tween_callback(queue_free)

class_name Main
extends Area2D

const battle_failed_knot = "battle_failed"

@export var dialog_resource: Resource
@export var dialog_knot: String
@export var visibility_flag: String
@export var invert_visibility_flag: bool
@export var battle_scene_name: String
@export var after_battle_dialog_knot: String
@export var interaction_enabled: bool = true

@onready var collision_node: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var animation_node:  = $AnimatedSprite2D as AnimatedSprite2D

var dialog_data: DialogData
var after_battle_dialog_data: DialogData
var try_again_dialog_data: DialogData

# battle
@export var is_battle_scene_enabled: bool = false
@export var battle_scene_type: BattleScene.BattleSceneType
@export var battle_scene_players: Array[BattleScene.SceneCharacterType] 
@export var battle_scene_enemies: Array[BattleScene.SceneCharacterType] 
@export var is_battle_dialogue_enabled: bool = false
@export var battle_dialog_triggers: Array[BattleScene.BattleDialogueSignalType]
@export var battle_dialog_knots: Array[String]
@export var battle_music_filename: String
@export var battle_music_volume: float = -7
var _battle_scene: Dictionary # <Main.SceneDataType, ?>

func _ready():
	body_entered.connect(_on_body_entered)
	
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_knot)
	
	if is_battle_scene_enabled:
		var dialogue_data = {}
		try_again_dialog_data = DialogData.new(dialog_resource, battle_failed_knot)
		if is_battle_dialogue_enabled:
			for i in range(battle_dialog_triggers.size()):
				var trigger = battle_dialog_triggers[i]
				dialogue_data[trigger] = DialogData.new(dialog_resource, battle_dialog_knots[i])
		_battle_scene = {
			SceneTransition.SceneDataType.BATTLE_BACK_TYPE: battle_scene_type,
			SceneTransition.SceneDataType.BATTLE_ENEMY_DICT: battle_scene_enemies,
			SceneTransition.SceneDataType.BATTLE_PLAYER_DICT: battle_scene_players,
			SceneTransition.SceneDataType.BATTLE_DIALOGUE: dialogue_data
		}
		# чтобы работало только когда есть и диалог, и баттл сцена
		if dialog_data != null && after_battle_dialog_knot != "":
			after_battle_dialog_data = DialogData.new(dialog_resource, after_battle_dialog_knot)
		
	if visibility_flag != null && visibility_flag != "":
		_update_visible()
		EventBus.game_vars_changed.connect(_update_visible)
	
	if animation_node != null && animation_node.sprite_frames != null && animation_node.sprite_frames.has_animation("default"):
		animation_node.play("default")

func _update_visible():
	var flag_value = GameState.vars.get(visibility_flag, false)
	print("Updating visibility for " + self.name + ", flag: " + str(visibility_flag) + " = " + str(flag_value) + ", inverted = " + str(invert_visibility_flag))
	if flag_value != invert_visibility_flag:
		show()
		collision_node.disabled = false
	else:
		hide()
		collision_node.disabled = true

func _on_body_entered(body):
	if !interaction_enabled || body == null || !body.is_in_group("Player"):
		return
	
	if dialog_data != null:
		EventBus.dialog_start.emit(dialog_data)
		await EventBus.dialog_finished
	if is_battle_scene_enabled:
		var result = await _start_battle()
		if result == EventBus.BattleEndType.DEFEAT:
			await _on_defeat()
		if after_battle_dialog_data != null:
			EventBus.dialog_start.emit(after_battle_dialog_data)
			await EventBus.dialog_finished
	EventBus.player_interaction_ended.emit()

func _on_defeat():
	var result = EventBus.BattleEndType.DEFEAT
	while result != EventBus.BattleEndType.VICTORY:
		EventBus.dialog_start.emit(try_again_dialog_data)
		await EventBus.dialog_finished
		result = await _start_battle()

func _start_battle():
	EventBus.music_replace.emit(battle_music_filename, battle_music_volume)
	EventBus.battle_request.emit(_battle_scene)
	return await EventBus.battle_scene_end
		

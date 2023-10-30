class_name Main
extends Area2D

@export var dialog_resource: Resource
@export var dialog_vars: Array[String]
@export var dialog_knot: String
@export var visibility_flag: String
@export var invert_visibility_flag: bool
@export var battle_scene_name: String
@export var after_battle_dialog_knot: String

@onready var collision_node: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var animation_node:  = $AnimatedSprite2D as AnimatedSprite2D

var dialog_data: DialogData
var after_battle_dialog_data: DialogData

@export var is_battle_scene_enabled: bool = false
@export var battle_scene_type: BattleScene.BattleSceneType
@export var battle_scene_players: Array[BattleScene.SceneCharacterType] 
@export var battle_scene_enemies: Array[BattleScene.SceneCharacterType] 
var _battle_scene: Dictionary # <Main.SceneDataType, ?>

func _ready():
	body_entered.connect(_on_body_entered)
	
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_vars, dialog_knot)
	
	if is_battle_scene_enabled:
		_battle_scene = {
			SceneTransition.SceneDataType.BATTLE_BACK_TYPE: battle_scene_type,
			SceneTransition.SceneDataType.BATTLE_ENEMY_DICT: battle_scene_enemies,
			SceneTransition.SceneDataType.BATTLE_PLAYER_DICT: battle_scene_players
		}
		# чтобы работало только когда есть и диалог, и баттл сцена
		if dialog_data != null && after_battle_dialog_knot != null:
			after_battle_dialog_data = DialogData.new(dialog_resource, dialog_vars, after_battle_dialog_knot)
		
	if visibility_flag != null && visibility_flag != "":
		_update_visible()
		EventBus.game_state_changed.connect(_update_visible)
	
	if animation_node != null:
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
	if body == null || !body.is_in_group("Player"):
		return
	
	if dialog_data != null:
		EventBus.dialog_start.emit(dialog_data)
		await EventBus.dialog_finished
	if is_battle_scene_enabled:
		EventBus.battle_request.emit(_battle_scene)
		await EventBus.battle_scene_end
		if after_battle_dialog_data != null:
			EventBus.dialog_start.emit(after_battle_dialog_data)
			await EventBus.dialog_finished
	EventBus.player_interaction_ended.emit()

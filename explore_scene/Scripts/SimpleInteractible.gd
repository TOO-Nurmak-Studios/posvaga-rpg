extends CharacterBody2D

@export var dialog_resource: InkResource
@export var dialog_vars: Array[String]
@export var dialog_knot: String
@export var visibility_flag: String
@export var invert_visibility_flag: bool
@export var after_battle_dialog_knot: String
@export var interaction_enabled: bool = true

@export var is_battle_scene_enabled: bool = false
@export var battle_scene_type: BattleScene.BattleSceneType
@export var battle_scene_players: Array[BattleScene.SceneCharacterType]
@export var battle_scene_enemies: Array[BattleScene.SceneCharacterType]
var _battle_scene: Dictionary # <Main.SceneDataType, ?>

@onready var collision_node: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var animation_node:  = $AnimatedSprite2D as AnimatedSprite2D

var dialog_data: DialogData
var after_battle_dialog_data: DialogData

func _ready():
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_vars, dialog_knot)
	if is_battle_scene_enabled:
    		_battle_scene = {
    			SceneTransition.SceneDataType.BATTLE_BACK_TYPE: battle_scene_type,
    			SceneTransition.SceneDataType.BATTLE_ENEMY_DICT: battle_scene_enemies,
    			SceneTransition.SceneDataType.BATTLE_PLAYER_DICT: battle_scene_players
    		}
    		if dialog_data != null && after_battle_dialog_knot != null:
				after_battle_dialog_data = DialogData.new(dialog_resource, dialog_vars, after_battle_dialog_knot)
	if visibility_flag != null && visibility_flag != "":
		_update_visible()
		EventBus.game_state_changed.connect(_update_visible)
	if animation_node != null:
		animation_node.play("default")
		EventBus.cutscene_animation_start.connect(try_animation_for_cutscene)

func _update_visible():
	var flag_value = GameState.vars.get(visibility_flag, false)
	print("Updating visibility for " + self.name + ", flag: " + str(visibility_flag) + " = " + str(flag_value) + ", inverted = " + str(invert_visibility_flag))
	if flag_value != invert_visibility_flag:
		show()
		collision_node.disabled = false
	else:
		hide()
		collision_node.disabled = true

func try_animation_for_cutscene(object_name: String, animation_name: String):
	if !name.matchn(object_name):
		return

	# костыль, чтобы двери открывались и через них можно было пройти
	if animation_name == "open":
		collision_node.disabled = true
	else:
		collision_node.disabled = false

	animation_node.play(animation_name)
	EventBus.cutscene_animation_finished.emit()

func interact():
	if !interaction_enabled:
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

extends CharacterBody2D

@export var dialog_resource: Resource
@export var dialog_vars: Array[String]
@export var dialog_knot: String
@export var visibility_flag: String
@export var invert_visibility_flag: bool
@export var battle_scene_name: String

@onready var collision_node: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var animation_node:  = $AnimatedSprite2D as AnimatedSprite2D

var dialog_data: DialogData
var battle_scene: Resource

func _ready():
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_vars, dialog_knot)
	if battle_scene_name != null && battle_scene_name != "":
		battle_scene = load(battle_scene_name)
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
	animation_node.play(animation_name)
	EventBus.cutscene_animation_finished.emit()

func interact():
	if dialog_data != null:
		EventBus.dialog_start.emit(dialog_data)
		await EventBus.dialog_finished
	if battle_scene != null:
		EventBus.battle_request.emit(battle_scene)
		await EventBus.battle_scene_end
	EventBus.player_interaction_ended.emit()

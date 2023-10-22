extends CharacterBody2D

@export var dialog_resource: Resource
@export var dialog_vars: Array[String]
@export var dialog_knot: String
@export var visibility_flag: String

@onready var collision_node: CollisionShape2D = $CollisionShape2D as CollisionShape2D

var dialog_data: DialogData

var test_dialog = DialogData.new(
	preload("res://dialog_scene/ink/institute_start.ink.json"),
	["test_dialog_visited"],
	"zavlab_entrance")

func _ready():
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_vars, dialog_knot)
	else:
		dialog_data = test_dialog
	if visibility_flag != null && visibility_flag != "":
		EventBus.game_state_changed.connect(_update_visible)

func _update_visible():
	if GameState.vars.get(visibility_flag):
		hide()
		collision_node.disabled = true
	else:
		show()
		collision_node.disabled = false

func interact():
	EventBus.dialog_start.emit(dialog_data)
	await EventBus.dialog_finished
	
	# just as a test example
	#EventBus.battle_request.emit(test_battle_scene)

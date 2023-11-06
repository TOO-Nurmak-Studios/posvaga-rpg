class_name NPC
extends MovableCharacter

@export var dialog_resource: Resource
@export var dialog_knot: String
@export var interaction_enabled: bool = true

var dialog_data: DialogData

func _ready():
	super()
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_knot)

func interact():
	if !interaction_enabled:
		return
	if dialog_resource != null:
		EventBus.dialog_start.emit(dialog_data)
		await EventBus.dialog_finished
	EventBus.player_interaction_ended.emit()

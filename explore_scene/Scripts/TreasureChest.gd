extends SimpleInteractible

const loot_dialog_knot = "item_found"
const loot_dialog_resource = preload("res://dialog_scene/ink/fantasy_starts.ink.json")
const loot_name_dialog_var = "item_name"
const loot_amount_dialog_var = "item_amount"

@export var items: Array[Item.Type]
@export var item_counts: Array[int]
@export var item_weights: Array[int]

var _loot_generator: LootGenerator

func _ready():
	super()
	_loot_generator = LootGenerator.new(items, item_counts, item_weights)
	dialog_data = DialogData.new(loot_dialog_resource, loot_dialog_knot)

func interact():
	var loot = _loot_generator.generate_loot()
	loot.add()
	GameState.set_var(loot_name_dialog_var, loot.get_item_name())
	GameState.set_var(loot_amount_dialog_var, loot.count)
	EventBus.dialog_start.emit(dialog_data)
	await EventBus.dialog_finished
	EventBus.player_interaction_ended.emit()

class_name ShopManager
extends CanvasLayer


const default_sprite_x = 320
const default_sprite_y = 160


@onready var sprite = $ItemSprite
@onready var name_label = $ItemNameLabel
@onready var count_label = $ItemCountLabel
@onready var cost_label = $ItemCostLabel
@onready var description_label = $ItemDescriptionLabel
@onready var gold_label = $GoldLabel


var current_item_index: int = 0
var current_item: Item


func _ready():
	EventBus.shop_open.connect(open)
	
	#hide()


func open():
	set_paused(true)
	current_item_index = 0
	try_set_item(0)
	set_current_gold()
	show()


func set_current_gold():
	var gold = ItemsManager.get_current_gold()
	gold_label.text = str("Got: $", gold)


func try_set_item(index: int):
	var available_items = ItemsManager.get_available_items()
	
	if index >= available_items.size() or index < 0:
		return
	
	var item: Item = available_items[index]
	var current_stack: ItemsStack = ItemsManager.get_current_inventory().get_by_id(item.id)
	var current_count = 0 if current_stack == null else current_stack.count
	
	sprite.texture = load(item.texture_full_file_name)
	sprite.scale = Vector2(default_sprite_x / sprite.texture.get_size().x, default_sprite_y / sprite.texture.get_size().y)
	
	name_label.text = item.item_name
	count_label.text = str(current_count)
	description_label.text = item.description
	cost_label.text = str("Cost: $", item.cost)
	
	current_item_index = index
	current_item = item


func set_paused(paused: bool):
	get_tree().paused = paused


func _on_next_button_pressed():
	try_set_item(current_item_index + 1)


func _on_prev_button_pressed():
	try_set_item(current_item_index - 1)


func _on_add_button_pressed():
	ItemsManager.get_current_inventory().put_and_pay(current_item, 1)
	try_set_item(current_item_index)
	set_current_gold()


func _on_close_button_pressed():
	EventBus.shop_closed.emit()
	hide()
	set_paused(false)

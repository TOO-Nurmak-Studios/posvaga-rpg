extends Node

var known_items: Dictionary = {} ## String to Item

## Доступные в магазине предметы для пати
var shop_items: Dictionary = {} ## String to Array[String]

func get_item_by_type(type: Item.Type):
	match type:
		Item.Type.SYROK:
			return Syrok.new()
		Item.Type.LIHO:
			return Liho.new()

func _ready():
	add_shop_item("irl", Syrok.new())
	add_shop_item("irl", Liho.new())

func add_shop_item(party_key: String, item: Item):
	if not known_items.has(item.id):
		known_items[item.id] = item
	
	if not shop_items.has(party_key):
		shop_items[party_key] = [ item.id ]
	else:
		shop_items[party_key].push_back(item.id)

func get_shop_items(party_key: String = ""):
	if party_key.is_empty():
		party_key = GameState.curParty.key
	
	var result: Array[Item] = []
	
	if not shop_items.has(party_key):
		return result
	
	var item_ids: Array = shop_items[party_key]
	
	for item_id in item_ids:
		var item = known_items.get(item_id)
		if item != null:
			result.push_back(item)
	
	return result

func get_current_gold() -> int:
	return get_current_inventory().gold

func get_current_items() -> Dictionary:
	return get_current_inventory().items

func get_current_inventory() -> Inventory:
	return GameState.curParty.inventory

extends Node

var known_items: Dictionary = {} ## String to Item
var available_items: Dictionary = {} ## String to Array[String]

func add_available_item(party_key: String, item: Item):
	if not known_items.has(item.id):
		known_items[item.id] = item
	
	if not available_items.has(party_key):
		available_items[party_key] = [ item.id ]
	else:
		available_items[party_key].push_back(item.id)

func get_available_items(party_key: String = ""):
	if party_key.is_empty():
		party_key = GameState.curParty.key
	
	var result: Array[Item] = []
	
	if not available_items.has(party_key):
		return result
	
	var item_ids: Array = available_items[party_key]
	
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

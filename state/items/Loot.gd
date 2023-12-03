class_name Loot
extends Node

var type: Item.Type
var item: Item
var count: int

func _init(_type: Item.Type, _count: int):
	type = _type
	count = _count
	if type != Item.Type.GOLD:
		item = ItemsManager.get_item_by_type(type)

func get_item_name():
	if type == Item.Type.GOLD:
		return "Золото"
	else:
		return item.item_name

func add():
	var inventory = GameState.curParty.inventory
	if type == Item.Type.GOLD:
		inventory.add_gold(count)
	else:
		inventory.put(item, count)

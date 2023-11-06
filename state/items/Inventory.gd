class_name Inventory


var gold: int = 0
var items: Dictionary = {} ## String to ItemsStack

## items


func get_by_id(id: String) -> ItemsStack:
	return items.get(id)


func put(item: Item, count: int = 1):
	var id = item.id
	if items.has(id):
		items[id].add(count)
	else:
		items[id] = ItemsStack.new(item, count)


func put_and_pay(item: Item, count: int):
	remove_gold(item.cost * count)
	put(item, count)


func remove(id: String, count: int = 1):
	if not items.has(id):
		return
	
	items[id].remove(count)
	
	if items[id].is_empty():
		items.erase(id)


func clear():
	remove_all_gold()
	items = {}


func count(id: String) -> int:
	if not items.has(id):
		return 0
	else:
		return items[id].count


func is_empty():
	return items.is_empty()


func size():
	return items.size()


## gold


func add_gold(to_add: int):
	gold += to_add


func remove_gold(to_remove: int):
	gold -= to_remove
	if gold < 0:
		gold = 0


func remove_all_gold():
	gold = 0

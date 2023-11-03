class_name Inventory


var gold: int = 0
var items: Dictionary = {} ## String to ItemsStack


## items


func get_by_type_id(type_id: String) -> ItemsStack:
	return items.get(type_id)


func put(item: Item, count: int = 1):
	var type_id = item.type_id
	if items.has(type_id):
		items[type_id].add(count)
	else:
		items[type_id] = ItemsStack.new(item, count)


func put_and_pay(item: Item, count: int, cost: int):
	remove_gold(cost)
	put(item, count)


func remove(type_id: String, count: int = 1):
	if not items.has(type_id):
		return
	
	items[type_id].remove(count)
	
	if items[type_id].is_empty():
		items.erase(type_id)


func clear():
	remove_all_gold()
	items = {}


func count(type_id: String) -> int:
	if not items.has(type_id):
		return 0
	else:
		return items[type_id].count


func use(type_id: String):
	var stack = items.get(type_id)
	if stack != null:
		stack.use_item()


## gold


func add_gold(to_add: int):
	gold += to_add


func remove_gold(to_remove: int):
	gold -= to_remove
	if gold < 0:
		gold = 0


func remove_all_gold():
	gold = 0

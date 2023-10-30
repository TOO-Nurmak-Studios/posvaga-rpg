class_name ItemsStack


var example_item: Item
var count: int


func _init(_example_item: Item, _count: int):
	example_item = _example_item
	count = _count


func is_empty() -> bool:
	return count == 0


func is_not_empty() -> bool:
	return count != 0


func has_at_least(_count: int) -> bool:
	return count >= _count


func add(to_add: int):
	count += to_add


func remove(to_remove: int):
	count -= to_remove
	if count < 0:
		count = 0


func use_item():
	if count > 0:
		EventBus.item_use.emit(example_item.type_id)
		count -= 1

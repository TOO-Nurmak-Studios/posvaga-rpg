class_name InventoryTest
## todo: remove after tests


func _init():
	EventBus.item_use.connect(on_item_used)


func test():
	test_add_and_remove_gold()
	test_get_put_remove()
	test_buy()
	test_use_item()


func test_add_and_remove_gold():
	print("InventoryTest: test_add_and_remove_gold")
	GameState.simParty.inventory.add_gold(5)
	GameState.simParty.inventory.remove_gold(3)
	print("InventoryTest: gold: ", GameState.simParty.inventory.gold)


func test_get_put_remove():
	print("InventoryTest: test_get_put_remove")
	print("InventoryTest: get_by_type_id: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	var item = Item.new("test_get_put_remove", "Предмет")
	GameState.simParty.inventory.put(item)
	print("InventoryTest: get_by_type_id after put 1: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	print("InventoryTest: count after put 1: ", GameState.simParty.inventory.count("test_get_put_remove"))
	GameState.simParty.inventory.remove("test_get_put_remove")
	print("InventoryTest: get_by_type_id after remove: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	print("InventoryTest: count after remove: ", GameState.simParty.inventory.count("test_get_put_remove"))
	GameState.simParty.inventory.put(item, 3)
	print("InventoryTest: get_by_type_id after put 3: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	print("InventoryTest: count after put 3: ", GameState.simParty.inventory.count("test_get_put_remove"))
	GameState.simParty.inventory.remove("test_get_put_remove", 2)
	print("InventoryTest: get_by_type_id after remove 2: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	print("InventoryTest: count after remove 2: ", GameState.simParty.inventory.count("test_get_put_remove"))
	GameState.simParty.inventory.remove("test_get_put_remove", 2)
	print("InventoryTest: get_by_type_id after remove 2: ", GameState.simParty.inventory.get_by_type_id("test_get_put_remove"))
	print("InventoryTest: count after remove 2: ", GameState.simParty.inventory.count("test_get_put_remove"))


func test_buy():
	print("InventoryTest: test_buy")
	var itemA1 = Item.new("test_buy", "Предмет")
	GameState.simParty.inventory.remove_all_gold()
	GameState.simParty.inventory.add_gold(5)
	print("InventoryTest: (1) gold: ", GameState.simParty.inventory.gold)
	print("InventoryTest: (1) count: ", GameState.simParty.inventory.count("test_buy"))
	GameState.simParty.inventory.put_and_pay(itemA1, 2, 4)
	print("InventoryTest: (2) gold: ", GameState.simParty.inventory.gold)
	print("InventoryTest: (2) count: ", GameState.simParty.inventory.count("test_buy"))


func test_use_item():
	print("InventoryTest: test_use_item")
	var item = Item.new("test_use_item", "Предмет")
	GameState.simParty.inventory.put(item, 1)
	print("InventoryTest: count: ", GameState.simParty.inventory.count("test_use_item"))
	GameState.simParty.inventory.use("test_use_item")
	print("InventoryTest: count: ", GameState.simParty.inventory.count("test_use_item"))


func on_item_used(type_id: String):
	print("InventoryTest: used item ", type_id)

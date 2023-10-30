extends Node

func initialize():
	EventBus.gold_add.connect(add_gold)
	EventBus.gold_remove.connect(remove_gold)
	print("InventoryManager: initialized")
	

func add_gold(to_add: int):
	print("InventoryManager: adding ", to_add, " gold")
	GameState.simParty.inventory.add_gold(to_add)
	print("InventoryManager: current gold: ", GameState.simParty.inventory.gold)


func remove_gold(to_remove: int):
	print("InventoryManager: removing ", to_remove, " gold")
	GameState.simParty.inventory.remove_gold(to_remove)
	print("InventoryManager: current gold: ", GameState.simParty.inventory.gold)

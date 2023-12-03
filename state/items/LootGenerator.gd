class_name LootGenerator

var _rand = BetterRandNumGen.new()

var _items: Array[Item.Type]
var _item_counts: Array[int]
var _item_weights: Array[int]

var _total_weight = 0


func _init(items: Array[Item.Type], item_counts: Array[int], item_weights: Array[int]):
	_items = items
	_item_counts = item_counts
	_item_weights = item_weights
	_total_weight = _item_weights.reduce(func(acc, next): return acc + next, 0)

func generate_loot() -> Loot:
	var index = RandomUtils.generate_weight_based_index(_item_weights, _total_weight)
	return Loot.new(_items[index], _item_counts[index])

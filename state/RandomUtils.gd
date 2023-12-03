extends Node

@onready var _rand = BetterRandNumGen.new()

func generate_weight_based_index(weights: Array, total_weight: int):
	var random_weight = _rand.randi_range(1, total_weight)
	var tmp_weight = 0
	var attack_index = 0
	var last_weight = 0
	for i in range(0, weights.size()):
		tmp_weight += weights[i]
		if (last_weight < random_weight && random_weight <= tmp_weight):
			return i
		last_weight = tmp_weight

class_name DialogUnit

var id: int
var replica: ReplicaData
var choice_options: Array[ChoiceOptionData]
var next_unit_id: int

func _init(_id: int, _replica: ReplicaData, _choice_options: Array[ChoiceOptionData], _next_unit_id: int):
	id = _id
	replica = _replica
	choice_options = _choice_options
	next_unit_id = _next_unit_id

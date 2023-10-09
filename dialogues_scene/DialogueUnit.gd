class_name DialogueUnit

var id: int
var replica: ReplicaData
## of type ChoiceOptionData
var choice_options: Array
var next_unit_id: int

func _init(_id: int, _replica: ReplicaData, _choice_options: Array, _next_unit_id: int):
	id = _id
	replica = _replica
	choice_options = _choice_options
	next_unit_id = _next_unit_id

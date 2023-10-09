class_name DialogueUnit

var id: int
var replica: ReplicaData
## of type ChoiceOptionData
var choice_options: Array

func _init(_id: int, _replica: ReplicaData, _choice_options: Array):
	id = _id
	replica = _replica
	choice_options = _choice_options

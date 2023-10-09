class_name ChoiceOptionData

enum Type { REPLICA, ACTION }

var type: Type
var text: String
var next_unit_id: int

func _init(_type: Type, _text: String, _next_unit_id: int):
	type = _type
	text = _text
	next_unit_id = _next_unit_id

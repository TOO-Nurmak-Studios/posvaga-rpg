class_name ChoiceData

enum Type { REPLICA, ACTION }

var id: int
var type: Type
var text: String

func _init(_id: int, _type: Type, _text: String):
	id = _id
	type = _type
	text = _text

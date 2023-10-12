class_name SpeakerData

var id: String
var name: String
var texture: Resource

func _init(_id: String, _name: String, _texture_path: String = ""):
	id = _id
	name = _name

	if !_texture_path.is_empty():
		texture = load(_texture_path)
	else:
		texture = load("res://sprites/dialog/" + _id + ".png")

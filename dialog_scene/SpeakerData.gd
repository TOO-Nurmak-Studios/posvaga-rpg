class_name SpeakerData

var id: String
var name: String
var texture: Resource
var invert_on_left: bool

func _init(_id: String, _name: String, _invert_on_left = false, _texture_path: String = ""):
	id = _id
	name = _name
	invert_on_left = _invert_on_left
	
	if !_texture_path.is_empty():
		texture = load(_texture_path)
	else:
		texture = load("res://sprites/dialog/" + _id + ".png")

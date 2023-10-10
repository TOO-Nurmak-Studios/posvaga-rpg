class_name ReplicaData

var speaker_name: String
var text: String
## symbols per second
var speed: float

func _init(_speaker_name: String, _text: String, _speed: float):
	speaker_name = _speaker_name
	text = _text
	speed = _speed

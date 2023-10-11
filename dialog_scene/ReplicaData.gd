class_name ReplicaData

var speaker_name: String
var text: String
## symbols per second
var speed: float
var sound_path: String

func _init(_speaker_name: String, _text: String, _speed: float, _sound_path: String):
	speaker_name = _speaker_name
	text = _text
	speed = _speed
	sound_path = _sound_path

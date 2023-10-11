class_name SpeakerData

enum Location { LEFT, RIGHT }

var speaker_name: String
var texture_path: String
var location: Location

func _init(_speaker_name: String, _texture_path: String, _location: Location):
	speaker_name = _speaker_name
	texture_path = _texture_path
	location = _location

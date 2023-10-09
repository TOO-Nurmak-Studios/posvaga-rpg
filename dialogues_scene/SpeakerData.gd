class_name SpeakerData

enum Location { LEFT, RIGHT }

var speaker_name: String
var texture_path: String
var location: Location

func _init(sn: String, tp: String, l: Location):
	speaker_name = sn
	texture_path = tp
	location = l

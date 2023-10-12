class_name ReplicaData

enum Location { LEFT, RIGHT }

var speaker: SpeakerData
var speaker_location: Location
var text: String
## symbols per second
var speed: float


func _init(
			_speaker: SpeakerData,
			_text: String,
			_speaker_location: Location = Location.LEFT,
			_speed: float = 18):

	speaker = _speaker
	text = _text
	speaker_location = _speaker_location
	speed = _speed

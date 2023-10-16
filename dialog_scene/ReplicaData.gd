class_name ReplicaData

enum SpeakerLocation { LEFT, RIGHT, DEFAULT }

var speaker: SpeakerData
var speaker_location: SpeakerLocation
var text: String
## symbols per second
var text_speed: float


func _init(
			_speaker: SpeakerData,
			_text: String,
			_speaker_location: SpeakerLocation = SpeakerLocation.LEFT,
			_text_speed: float = 18):

	speaker = _speaker
	text = _text
	speaker_location = _speaker_location
	text_speed = _text_speed

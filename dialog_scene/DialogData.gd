class_name DialogData

var speakers: Array[SpeakerData]
var units: Array[DialogUnit]
var print_sound_path: String

func _init(_speakers: Array[SpeakerData], _units: Array[DialogUnit], _print_sound_path: String):
	speakers = _speakers
	units = _units
	print_sound_path = _print_sound_path

class_name DialogueData

var speakers: Array[SpeakerData]
var units: Array[DialogueUnit]

func _init(_speakers: Array[SpeakerData], _units: Array[DialogueUnit]):
	speakers = _speakers
	units = _units

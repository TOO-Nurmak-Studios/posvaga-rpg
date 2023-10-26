class_name DialogTag


enum Type { SPEAKER_ID, SPEAKER_LOCATION, SPEAKER_SPEED, CUTSCENE_STEP, SOUND, MUSIC }


var type: Type
var params: PackedStringArray


func _init(source: String):
	var split = source.split(": ")
	var tag_name = split[0]
	var tag_value = split[1]
	
	params = tag_value.split(" ")

	match tag_name:
		"sid":
			type = Type.SPEAKER_ID
		"loc":
			type = Type.SPEAKER_LOCATION
		"spd":
			type = Type.SPEAKER_SPEED
		"cts":
			type = Type.CUTSCENE_STEP
		"snd":
			type = Type.SOUND
		"mus":
			type = Type.MUSIC

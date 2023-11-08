class_name DialogTag


enum Type { SPEAKER_ID, SPEAKER_LOCATION, SPEAKER_SPEED, CUTSCENE_STEP, SOUND, MUSIC, ENV, STOP }


var type: Type
var params: PackedStringArray


func _init(source: String):
	var split = source.split(": ")
	var tag_name = split[0]
	var tag_value = split[1] if split.size() > 1 else ""
	
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
		"env":
			type = Type.ENV
		"stp":
			type = Type.STOP

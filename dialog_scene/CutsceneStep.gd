class_name CutsceneStep

enum Type { FADE, WAIT, MOVE, TURN }

var type: Type
var params: PackedStringArray

func _init(_type: String, _description: String):
	match _type:
		"fade":
			type = Type.FADE
		"wait":
			type = Type.WAIT
		"move":
			type = Type.MOVE
		"turn":
			type = Type.TURN
	
	params = _description.split(" ")

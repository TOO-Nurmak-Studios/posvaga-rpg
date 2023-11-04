class_name CutsceneStep

enum Type { FADE, WAIT, MOVE, TURN, ANIM, REMV, SCEN }

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
		"anim":
			type = Type.ANIM
		"remv":
			type = Type.REMV
		"scen":
			type = Type.SCEN
	
	params = _description.replace("\n", "").split(" ")

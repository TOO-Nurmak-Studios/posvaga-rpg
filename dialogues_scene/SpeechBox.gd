extends Control

class_name SpeechBox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_unit(unit: SpeechUnit):
	set_speaker(unit.speaker)
	set_replica(unit.replica)

func set_speaker(speaker: String):
	$Rect/SpeakerLabel.text = speaker + ":"

func set_replica(replica: String):
	$Rect/ReplicaLabel.text = replica

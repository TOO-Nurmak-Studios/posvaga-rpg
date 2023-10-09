class_name ReplicasBox

extends Control

func _ready():
	pass

func _process(delta):
	pass

func set_replica(replica: ReplicaData):
	$Rect/SpeakerNameLabel.text = replica.speaker_name + ":"
	$Rect/TextLabel.text = replica.text

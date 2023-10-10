class_name ReplicasBox

extends Control

var full_text: String
var seconds_before_next_symbol: float
var is_printing: bool

func _ready():
	pass

func _process(delta):
	pass

func set_replica(replica: ReplicaData):
	$Rect/SpeakerNameLabel.text = replica.speaker_name + ":"
	$Rect/TextLabel.text = ""
	full_text = replica.text
	seconds_before_next_symbol = 1 / replica.speed
	is_printing = true
	print_text()

func print_text():
	for symbol in full_text:
		$Rect/TextLabel.text += symbol
		await get_tree().create_timer(seconds_before_next_symbol).timeout
		if (not is_printing):
			return
	is_printing = false
	
func show_full_text():
	$Rect/TextLabel.text = full_text
	is_printing = false

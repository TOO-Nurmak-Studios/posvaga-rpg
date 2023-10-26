class_name FootstepsPlayer

extends Node

@onready var audio_player = $AudioStreamPlayer

var sprint_speed_modifier: float
var is_playing: bool = false

func set_sprint_speed_modifier(modifier: float):
	sprint_speed_modifier = modifier

func set_sprint():
	audio_player.pitch_scale = sprint_speed_modifier

func set_no_sprint():
	audio_player.pitch_scale = 1

func process_for(velocity: Vector2):
	if velocity.x != 0 or velocity.y != 0:
		if not is_playing:
			audio_player.play()
			is_playing = true
	else:
		audio_player.stop()
		is_playing = false

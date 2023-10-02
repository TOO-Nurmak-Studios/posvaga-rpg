extends Node

signal action_button_pressed()
signal player_projectile_landed()

func _process(delta):
	if Input.is_action_just_pressed("debug_action_1"):
		action_button_pressed.emit()
	pass

func emit_player_projectile_landed():
	player_projectile_landed.emit()

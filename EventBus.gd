extends Node

signal action_button_pressed()
signal select_next_button_pressed()
signal select_prev_button_pressed()
signal player_attack_landed(attack: Attack)

func _process(delta):
	if Input.is_action_just_pressed("debug_action_1"):
		action_button_pressed.emit()
	else: if Input.is_action_just_pressed("select_next"):
		select_next_button_pressed.emit()
	else: if Input.is_action_just_pressed("select_prev"):
		select_prev_button_pressed.emit()

func emit_player_attack_landed(attack: Attack):
	player_attack_landed.emit(attack)

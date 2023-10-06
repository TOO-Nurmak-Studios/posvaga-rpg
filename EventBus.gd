extends Node

signal action_button_pressed()
signal select_next_button_pressed()
signal select_prev_button_pressed()
signal player_attack_landed(attack: Attack)

signal player_move_pressed(delta: float, vector: Vector2)
signal player_sprint_pressed()
signal player_sprint_released()


func _process(delta):
	if Input.is_action_just_pressed("debug_action_1"):
		action_button_pressed.emit()
	if Input.is_action_just_pressed("select_next"):
		select_next_button_pressed.emit()
	if Input.is_action_just_pressed("select_prev"):
		select_prev_button_pressed.emit()
	
	if Input.is_action_just_pressed("ui_sprint"):
		player_sprint_pressed.emit()
	elif Input.is_action_just_released("ui_sprint"):
		player_sprint_released.emit()
	
	var player_move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player_move_pressed.emit(delta, player_move_vector)


func emit_player_attack_landed(attack: Attack):
	player_attack_landed.emit(attack)

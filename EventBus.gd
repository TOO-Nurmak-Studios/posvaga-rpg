extends Node

#input
signal action_button_pressed()
signal select_next_button_pressed()
signal select_prev_button_pressed()
signal select_left_button_pressed()
signal select_right_button_pressed()

#battle scene
signal attack_ended(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack)
signal battle_scene_end()

#explore scene, player controls
var player_input_enabled = true

signal player_move_pressed(delta: float, vector: Vector2)
signal player_sprint_pressed()
signal player_sprint_released()
signal player_interact_pressed()

#dialog
signal dialog_start(dialog_data: DialogData)
signal dialog_finished()

#cutscene
signal cutscene_step_start(step: CutsceneStep)
signal cutscene_step_finished()
signal cutscene_move_start(object: String, direction: String, distance: int)
signal cutscene_move_finished()
signal cutscene_turn_start(object: String, direction: String)
signal cutscene_turn_finished()
signal cutscene_wait_start(seconds: float)
signal cutscene_wait_finished()
signal cutscene_fade_start(type: String)
signal cutscene_fade_finished()

# game state
# пока один сигнал на всё - мб нужно будет распилить
# ещё непонятно, как отслеживать, что этот сигнал всегда вызывается
signal game_state_changed()

#scene transitions
signal teleport_request(scene: Resource, player_position: Vector2, player_direction: Vector2)
signal battle_request(scene: Resource)

func _process(delta):
	if Input.is_action_just_pressed("select_next"):
		select_next_button_pressed.emit()
	if Input.is_action_just_pressed("select_prev"):
		select_prev_button_pressed.emit()
	if Input.is_action_just_pressed("select_left"):
		select_left_button_pressed.emit()
	if Input.is_action_just_pressed("select_right"):
		select_right_button_pressed.emit()
	if Input.is_action_just_pressed("debug_action_1"):
		action_button_pressed.emit()

	if player_input_enabled:
		process_player_input(delta)

func process_player_input(delta):
	if Input.is_action_pressed("ui_sprint"):
		player_sprint_pressed.emit()
	elif Input.is_action_just_released("ui_sprint"):
		player_sprint_released.emit()
	
	if Input.is_action_just_pressed("ui_interact"):
		player_interact_pressed.emit()
	
	var player_move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player_move_pressed.emit(delta, player_move_vector)

func emit_attack_ended(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	attack_ended.emit(attacker, attacked, attack)

func emit_battle_scene_end():
	battle_scene_end.emit()

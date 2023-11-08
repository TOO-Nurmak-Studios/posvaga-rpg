extends Node

#input
signal action_button_pressed()
signal action_back_button_pressed()
signal select_next_button_pressed()
signal select_prev_button_pressed()
signal select_left_button_pressed()
signal select_right_button_pressed()
signal pause_button_pressed()

#battle scene
signal attack_ended(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack)
signal battle_scene_start()
enum BattleEndType {VICTORY, DEFEAT}
signal battle_scene_fade_away(result: BattleEndType)
signal battle_scene_end(result: BattleEndType)

#explore scene, player controls
var player_input_enabled = true
var player_in_battle = false

signal player_move_pressed(delta: float, vector: Vector2)
signal player_sprint_pressed()
signal player_sprint_released()
signal player_interact_pressed()
signal player_interaction_ended()

#dialog
var dialog_input_enabled = true

signal dialog_start(dialog_data: DialogData)
signal dialog_finished()

#cutscene
signal cutscene_step_start(step: CutsceneStep)
signal cutscene_step_finished()
signal cutscene_move_start(object: String, direction: String, distance: int, sprint: bool)
signal cutscene_move_finished()
signal cutscene_turn_start(object: String, direction: String)
signal cutscene_turn_finished()
signal cutscene_animation_start(object: String, animation_name: String)
signal cutscene_animation_finished()
signal cutscene_wait_start(seconds: float)
signal cutscene_wait_finished()
signal cutscene_fade_start(type: String, speed: float)
signal cutscene_fade_finished()
signal cutscene_remove_object()
signal cutscene_change_scene(path: String)

# audio
signal music_play_new(file: String, down_seconds: String, up_seconds: String, volume: String)
signal music_play_and_replace_back(file: String)
signal music_play()
signal music_pause()
signal music_stop(down_seconds: String)
signal music_replace(file: String)
signal music_replace_back()
signal sound_play(file: String, volume: String)
signal env_play_new(file: String, down_seconds: String, up_sedonds: String, volume: String)
signal env_play()
signal env_pause()
signal env_stop(down_seconds: String)

# game state
# поменялись переменные (флаги)
signal game_vars_changed()
# поменялось состояние (енам)
signal game_state_changed()

# inventory
signal item_use(type_id: String)

#scene transitions
signal teleport_request(scene: Resource, player_position: Vector2, player_direction: Vector2)
signal battle_request(battle_data: Dictionary)

#pause
signal pause_start()
signal pause_finish()


func _ready():
	self.process_mode = PROCESS_MODE_ALWAYS


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_button_pressed.emit()
	
	# если игра на паузе, обрабатываем только выход из паузы
	if get_tree().paused:
		return
	
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
	if Input.is_action_just_pressed("back"):
		action_back_button_pressed.emit()

	process_player_input(delta)

func process_player_input(delta):
	if Input.is_action_pressed("ui_sprint"):
		player_sprint_pressed.emit()
	elif Input.is_action_just_released("ui_sprint"):
		player_sprint_released.emit()
	
	# оставляем только сигналы на спринт, иначе может получится так,
	# что игро забегает в диалог, игра не ловит отпущенный шифт,
	# и после выхода из диалога персонажа в вечном спринте
	if !player_input_enabled || player_in_battle:
		return
	
	if Input.is_action_just_pressed("ui_interact"):
		player_interact_pressed.emit()
	
	var player_move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player_move_pressed.emit(delta, player_move_vector)

func emit_attack_ended(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	attack_ended.emit(attacker, attacked, attack)

func emit_battle_scene_start():
	battle_scene_start.emit()
	
func emit_battle_scene_fade_away(result: BattleEndType):
	battle_scene_fade_away.emit(result)

func emit_battle_scene_end(result: BattleEndType):
	battle_scene_end.emit(result)

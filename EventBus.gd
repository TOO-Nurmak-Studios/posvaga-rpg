extends Node

#input
signal action_button_pressed()
signal select_next_button_pressed()
signal select_prev_button_pressed()

#battle scene
signal attack_landed(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack)
signal battle_scene_end()
signal battle_scene_fully_ready()

signal player_move_pressed(delta: float, vector: Vector2)
signal player_sprint_pressed()
signal player_sprint_released()
signal player_interact_pressed()

signal dialog_start(ink_story: Resource, is_cutscene: bool)

func _ready():
	var root_scene = $/root/BattleField as Node
	if root_scene != null:
		root_scene.ready.connect(_emit_battle_scene_fully_ready)

func _emit_battle_scene_fully_ready():
	battle_scene_fully_ready.emit()

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
	
	if Input.is_action_just_pressed("ui_interact"):
		player_interact_pressed.emit()
	
	var player_move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player_move_pressed.emit(delta, player_move_vector)

func emit_attack_landed(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	attack_landed.emit(attacker, attacked, attack)

func emit_battle_scene_end():
	battle_scene_end.emit()

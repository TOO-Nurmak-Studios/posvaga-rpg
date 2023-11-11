extends Node2D

enum Mode {EXPLORATION, BATTLE}

var current_mode: Mode

var current_exploration_scene: Node
var player: ExplorePlayer

var current_battle_scene: Node

var default_start_scene = load("res://explore_scene/Scenes/Institute_LabRoom_Start.tscn")
const default_start_dialog = preload("res://dialog_scene/ink/institute_start.ink.json")

var start_scene: Resource
var start_dialog = DialogData.new(default_start_dialog)

func init(_start_scene_name: String):
	if _start_scene_name != null && _start_scene_name != "":
		start_scene = load(_start_scene_name)


func _ready():
	await SceneTransition.fade_in()
	
	EventBus.teleport_request.connect(_teleport)
	EventBus.battle_request.connect(_battle)
	EventBus.battle_scene_end.connect(_battle_finished)
	EventBus.cutscene_wait_start.connect(wait)
	EventBus.cutscene_fade_start.connect(fade)
	EventBus.cutscene_change_scene.connect(_cutscene_change_scene)
	
	_init_state()
	InventoryTest.new().test()
	
	if start_scene != null:
		_change_scene({SceneTransition.SceneDataType.PACKED_SCENE: start_scene}, Mode.EXPLORATION)
		SceneTransition.fade_out()
	else:
		_game_start()

# С этой функции будет начинаться вся игра
# для дебага лучше менять логику в _ready()
func _game_start():
	_change_scene({SceneTransition.SceneDataType.PACKED_SCENE: default_start_scene}, Mode.EXPLORATION)
	EventBus.dialog_start.emit(start_dialog)

func _init_state():
	var vera = CharacterState.new(100, 100, [], null, null, null)
	var chapter_one_party = PartyState.new(vera, null, null, Inventory.new())
	GameState.irlParty = chapter_one_party
	GameState.curParty = chapter_one_party
	GameState.simParty = PartyState.new(null, null, null, Inventory.new())

# игрок наступил на телепорт и переходит в новую сцену через фейд
func _teleport(scene: Resource, player_pos: Vector2, player_dir: Vector2):
	await SceneTransition.fade_in()
	_change_scene({SceneTransition.SceneDataType.PACKED_SCENE: scene}, Mode.EXPLORATION, player_pos, player_dir)
	SceneTransition.fade_out()

# катсцена требует сменить сцену, меняем без фейда и постановки игрока, отправляем сигнал, блокируем игрока
func _cutscene_change_scene(scene_path: String):
	var scene = load(scene_path)
	_change_scene({SceneTransition.SceneDataType.PACKED_SCENE: scene}, Mode.EXPLORATION)
	EventBus.player_input_enabled = false
	# жесточайший костыль чтобы напомнить игроку, что мы в диалоге
	current_exploration_scene.get_node("Player")._process_dialog_start(null)
	EventBus.cutscene_step_finished.emit()

func _battle(scene_data: Dictionary):
	_change_scene(scene_data, Mode.BATTLE)

func _battle_finished(_a):
	current_exploration_scene.show()
	current_exploration_scene.set_process(true)
	current_exploration_scene.set_physics_process(true)
	current_exploration_scene.set_process_input(true)
	EventBus.player_input_enabled = true
	
	current_battle_scene.hide()
	current_battle_scene.queue_free.call_deferred()
	
	SceneTransition.fade_out()

func _change_scene(
				new_scene_data: Dictionary,
				mode: Mode, 
				player_pos: Vector2 = Vector2.ZERO,
				player_dir: Vector2 = Vector2.ZERO):
					
	var old_scene
	
	if mode == Mode.EXPLORATION:
		old_scene = current_exploration_scene
		var scene = new_scene_data[SceneTransition.SceneDataType.PACKED_SCENE]
		current_exploration_scene = scene.instantiate()
		add_child(current_exploration_scene)
		
		player = current_exploration_scene.get_node("Player")
		
		current_mode = Mode.EXPLORATION
		
		if (player_pos != Vector2.ZERO):
			player.position = player_pos
		if (player_dir != Vector2.ZERO):
			player.face_direction(player_dir)
			
		EventBus.player_input_enabled = true
	elif mode == Mode.BATTLE:
		old_scene = current_battle_scene
		
		current_battle_scene = BattleScene.instantiate_battle_scene(
			new_scene_data[SceneTransition.SceneDataType.BATTLE_BACK_TYPE],
			new_scene_data[SceneTransition.SceneDataType.BATTLE_PLAYER_DICT],
			new_scene_data[SceneTransition.SceneDataType.BATTLE_ENEMY_DICT],
			new_scene_data[SceneTransition.SceneDataType.BATTLE_DIALOGUE]
		)
		add_child(current_battle_scene)
		
		current_mode = Mode.BATTLE
		
		if current_exploration_scene != null:
			current_exploration_scene.hide()
			current_exploration_scene.set_process(false)
			current_exploration_scene.set_physics_process(false)
			current_exploration_scene.set_process_input(false)
			EventBus.player_input_enabled = false
	
	if old_scene != null:
			old_scene.hide()
			old_scene.queue_free.call_deferred()


func wait(seconds_to_wait: float):
	await get_tree().create_timer(seconds_to_wait, true, true).timeout
	EventBus.cutscene_wait_finished.emit()

func fade(type: String, speed: float = 1.0):
	match type:
		"in":
			await SceneTransition.fade_in(speed)
		"out":
			await SceneTransition.fade_out(speed)
	EventBus.cutscene_fade_finished.emit()

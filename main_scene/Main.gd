extends Node2D

enum Mode {EXPLORATION, BATTLE}

var current_mode: Mode

var current_exploration_scene: Node
var player: ExplorePlayer

var current_battle_scene: Node

const default_start_scene = preload("res://explore_scene/Scenes/Institute_LabRoom.tscn")
var start_scene: Resource

func init(_start_scene_name: String):
	if _start_scene_name != null:
		start_scene = load(_start_scene_name)

func _ready():
	EventBus.teleport_request.connect(_teleport)
	EventBus.battle_request.connect(_battle)
	EventBus.cutscene_wait_start.connect(wait)
	EventBus.cutscene_fade_start.connect(fade)
	
	if start_scene != null:
		_change_scene(start_scene, Mode.EXPLORATION)
	else:
		_change_scene(default_start_scene, Mode.EXPLORATION)

# С этой функции будет начинаться вся игра
# для дебага лучше менять логику в _ready()
func _game_start():
	_change_scene(default_start_scene, Mode.EXPLORATION)
	#SceneTransition.fade_out(0.02)

func _teleport(scene: Resource, player_pos: Vector2, player_dir: Vector2):
	await SceneTransition.fade_in()
	_change_scene(scene, Mode.EXPLORATION, player_pos, player_dir)
	SceneTransition.fade_out()

func _battle(scene: Resource):
	await SceneTransition.fade_in()
	_change_scene(scene, Mode.BATTLE)
	SceneTransition.fade_out()

func _change_scene(
				scene: Resource, 
				mode: Mode, 
				player_pos: Vector2 = Vector2.ZERO,
				player_dir: Vector2 = Vector2.ZERO):
					
	var old_scene
	
	if mode == Mode.EXPLORATION:
		old_scene = current_exploration_scene
		
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
		
		current_battle_scene = scene.instantiate()
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

func fade(type: String):
	match type:
		"in":
			await SceneTransition.fade_in()
		"out":
			await SceneTransition.fade_out()
	EventBus.cutscene_fade_finished.emit()

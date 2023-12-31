class_name CutsceneManager
extends Node

const scene_path_prefix = "res://explore_scene/Scenes/"
const scene_file_extension = ".tscn"


func _ready():
	EventBus.cutscene_step_start.connect(process_cutscene_step)
	EventBus.cutscene_move_finished.connect(on_step_finished)
	EventBus.cutscene_turn_finished.connect(on_step_finished)
	EventBus.cutscene_wait_finished.connect(on_step_finished)
	EventBus.cutscene_fade_finished.connect(on_step_finished)
	EventBus.cutscene_animation_finished.connect(on_step_finished)


func _process(delta):
	pass


func process_cutscene_step(step: CutsceneStep):
	match step.type:
		CutsceneStep.Type.FADE:
			process_fade(step.params)
		CutsceneStep.Type.WAIT:
			process_wait(step.params)
		CutsceneStep.Type.MOVE:
			process_move(step.params)
		CutsceneStep.Type.TURN:
			process_turn(step.params)
		CutsceneStep.Type.ANIM:
			process_animation(step.params)
		CutsceneStep.Type.REMV:
			process_remove(step.params)
		CutsceneStep.Type.SCEN:
			process_change_scene(step.params)
		CutsceneStep.Type.EXIT:
			process_exit()


func on_step_finished():
	EventBus.cutscene_step_finished.emit()


func process_fade(params: PackedStringArray):
	var type = params[0].replace("\n", "")
	var speed = 1.0
	if params.size() > 1:
		speed = params[1].replace("\n", "").to_float()
	EventBus.cutscene_fade_start.emit(type, speed)


func process_wait(params: PackedStringArray):
	var seconds = params[0].to_float()
	EventBus.cutscene_wait_start.emit(seconds)


func process_move(params: PackedStringArray):
	var object = params[0] as String
	var direction = params[1] as String
	var distance = params[2].to_float()
	var sprint = false
	if params.size() == 4:
		sprint = params[3] == "sprint"
	EventBus.cutscene_move_start.emit(object, direction, distance, sprint)


func process_turn(params: PackedStringArray):
	var object = params[0] as String
	var direction = params[1].replace("\n", "") as String
	EventBus.cutscene_turn_start.emit(object, direction)


func process_animation(params: PackedStringArray):
	var object = params[0] as String
	var animation_name = params[1] as String
	EventBus.cutscene_animation_start.emit(object, animation_name)


func process_remove(params: PackedStringArray):
	var object = params[0] as String
	EventBus.cutscene_remove_object.emit(object)


func process_change_scene(params: PackedStringArray):
	var scene_name = params[0] as String
	EventBus.cutscene_change_scene.emit(scene_path_prefix + scene_name + scene_file_extension)

func process_exit():
	get_tree().quit()

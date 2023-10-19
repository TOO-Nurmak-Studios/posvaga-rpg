class_name CutsceneManager

extends Node


func _ready():
	EventBus.cutscene_step_start.connect(process_cutscene_step)
	EventBus.cutscene_move_finished.connect(on_step_finished)
	EventBus.cutscene_turn_finished.connect(on_step_finished)
	EventBus.cutscene_wait_finished.connect(on_step_finished)
	EventBus.cutscene_fade_finished.connect(on_step_finished)


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


func on_step_finished():
	EventBus.cutscene_step_finished.emit()


func process_fade(params: PackedStringArray):
	var type = params[0].replace("\n", "")
	EventBus.cutscene_fade_start.emit(type)


func process_wait(params: PackedStringArray):
	var seconds = params[0].to_float()
	EventBus.cutscene_wait_start.emit(seconds)


func process_move(params: PackedStringArray):
	var object = params[0] as String
	var direction = params[1] as String
	var distance = params[2].to_int()
	EventBus.cutscene_move_start.emit(object, direction, distance)


func process_turn(params: PackedStringArray):
	var object = params[0] as String
	var direction = params[1].replace("\n", "") as String
	EventBus.cutscene_turn_start.emit(object, direction)

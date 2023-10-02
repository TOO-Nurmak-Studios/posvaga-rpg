extends Node2D

@onready var battle_manager: BattleManager = $BattleManager as BattleManager

func _process(delta):
	if Input.is_action_just_pressed("select_next"):
		battle_manager.select(BattleManager.Select.NEXT)
	if Input.is_action_just_pressed("select_prev"):
		battle_manager.select(BattleManager.Select.PREV)
	pass

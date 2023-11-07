extends Node2D

@export var dialog_resource: Resource
@export var dialog_vars: Array[String]
@export var dialog_knot: String

func _ready():
	var scene = BattleScene.instantiate_battle_scene(
		BattleScene.BattleSceneType.UNIVERSITY,
		[BattleScene.SceneCharacterType.LABORANTKA, BattleScene.SceneCharacterType.LABORANTKA],
		[BattleScene.SceneCharacterType.COCK_SMALL, BattleScene.SceneCharacterType.COCK_TUTOR],
		{}
	)
	
	add_child.call_deferred(scene)

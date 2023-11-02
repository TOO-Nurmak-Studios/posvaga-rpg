extends Node2D


func _ready():
	var scene = BattleScene.instantiate_battle_scene(
		BattleScene.BattleSceneType.UNIVERSITY,
		[BattleScene.SceneCharacterType.LABORANTKA, BattleScene.SceneCharacterType.LABORANTKA],
		[BattleScene.SceneCharacterType.COCK_SMALL, 
		BattleScene.SceneCharacterType.COCK_SMALL]
	)
	
	add_sibling.call_deferred(scene)

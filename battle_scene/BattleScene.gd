extends Node

enum BattleSceneType {PANTRY, UNIVERSITY}
enum BattleDialogueSignalType {ON_BATTLE_START, ON_FIRST_ATTACK, ON_SECOND_ATTACK}

var battle_scene_pantry = preload("res://battle_scene/BattleBackgrounds/BattleBackgroundPantry.tscn")
var battle_scene_uni = preload("res://battle_scene/BattleBackgrounds/BattleBackgroundUni.tscn")

func get_battle_scene(type: BattleSceneType):
	match type:
		BattleSceneType.PANTRY:
			return battle_scene_pantry.instantiate()
		BattleSceneType.UNIVERSITY:
			return battle_scene_uni.instantiate()

	return battle_scene_uni.instantiate()

enum SceneCharacterType {LABORANTKA, COCK_BIG, COCK_SMALL, COCK_TUTOR, PLAYER}

var scene_character_big_cock = preload("res://battle_scene/Entity/Enemies/Cockroach/Cockroach.tscn")
var scene_character_small_cock = preload("res://battle_scene/Entity/Enemies/Cockroach/SmallCockroach.tscn")
var scene_character_tutor_cock = preload("res://battle_scene/Entity/Enemies/Cockroach/SmallTutorialCockroach.tscn")
var scene_character_lab = preload("res://battle_scene/Entity/Players/Laborantka/Player.tscn")

func get_character(type: SceneCharacterType) -> AbstractCharacter:
	match type:
		SceneCharacterType.LABORANTKA:
			return scene_character_lab.instantiate()
		SceneCharacterType.COCK_BIG:
			return scene_character_big_cock.instantiate()
		SceneCharacterType.COCK_TUTOR:
			return scene_character_tutor_cock.instantiate()
		SceneCharacterType.COCK_SMALL:
			return scene_character_small_cock.instantiate()

	return scene_character_lab.instantiate()

var battle_field_preload_scene = preload("res://battle_scene/battle_field.tscn")

func instantiate_battle_scene(scene: BattleSceneType, 
							players: Array[SceneCharacterType], 
							enemies: Array[SceneCharacterType],
							dialogue: Dictionary): #<BattleDialogueSignalType, DialogData>
	var battle_field = battle_field_preload_scene.instantiate() as BattleField
	var battle_field_scene = get_battle_scene(scene) as BattleBackground
	
	var players_arr = []
	for player_type in players:
		players_arr.push_back(get_character(player_type))
	
	var enemys_arr = []
	for enemy_type in enemies:
		enemys_arr.push_back(get_character(enemy_type))
	
	battle_field.init(battle_field_scene, players_arr, enemys_arr, dialogue)
	
	return battle_field

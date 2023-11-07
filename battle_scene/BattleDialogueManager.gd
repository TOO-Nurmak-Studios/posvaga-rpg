extends Node
class_name BattleDialogueManager

var dialogue: Dictionary

var player_attack_amount = 0
var enemy_attack_amount = 0
var on_attack_connected = false
var player_attack_triggers: Dictionary = {}
var enemy_attack_triggers: Dictionary = {}

func init(dialogue: Dictionary):
	self.dialogue = dialogue
	
	for signal_type in dialogue:
		var dialog: DialogData = dialogue[signal_type] as DialogData
		match signal_type:
			BattleScene.BattleDialogueSignalType.ON_BATTLE_START:
				EventBus.battle_scene_start.connect(start_dialog.bind(dialog), CONNECT_ONE_SHOT)
			BattleScene.BattleDialogueSignalType.ON_FIRST_PLAYER_ATTACK:
				add_player_attack_trigger(dialog, 1)
			BattleScene.BattleDialogueSignalType.ON_SECOND_PLAYER_ATTACK:
				add_player_attack_trigger(dialog, 2)
			BattleScene.BattleDialogueSignalType.ON_FIRST_ENEMY_ATTACK:
				add_enemy_attack_trigger(dialog, 1)
			BattleScene.BattleDialogueSignalType.ON_SECOND_ENEMY_ATTACK:
				add_enemy_attack_trigger(dialog, 2)
			BattleScene.BattleDialogueSignalType.ON_THIRD_ENEMY_ATTACK:
				add_enemy_attack_trigger(dialog, 3)
			BattleScene.BattleDialogueSignalType.ON_FOURTH_ENEMY_ATTACK:
				add_enemy_attack_trigger(dialog, 4)
			BattleScene.BattleDialogueSignalType.ON_FIFTH_ENEMY_ATTACK:
				add_enemy_attack_trigger(dialog, 5)

func add_player_attack_trigger(dialog: DialogData, number):
	if !on_attack_connected:
		EventBus.attack_ended.connect(post_attack_dialogue)
		on_attack_connected = true
	player_attack_triggers[number] = dialog

func add_enemy_attack_trigger(dialog: DialogData, number):
	if !on_attack_connected:
		EventBus.attack_ended.connect(post_attack_dialogue)
		on_attack_connected = true
	enemy_attack_triggers[number] = dialog

func post_attack_dialogue(attacker, _b, _c):
	if attacker.get_type() == AbstractCharacter.CharacterType.ENEMY:
		enemy_attack_amount += 1
		if enemy_attack_triggers.has(enemy_attack_amount):
			await start_dialog(enemy_attack_triggers.get(enemy_attack_amount))
	elif attacker.get_type() == AbstractCharacter.CharacterType.PLAYER:
		player_attack_amount += 1
		if player_attack_triggers.has(player_attack_amount):
			await start_dialog(player_attack_triggers.get(player_attack_amount))

func start_dialog(dialog_data: DialogData, delay: float = 0.0):
	if delay != 0.0:
		await get_tree().create_timer(delay).timeout
	EventBus.dialog_start.emit(dialog_data)
	await EventBus.dialog_finished

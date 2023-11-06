extends Node
class_name BattleDialogueManager

var dialogue: Dictionary

var player_attack_amount = 0
var on_attack_connected = false
var attack_triggers: Dictionary = {}

func init(dialogue: Dictionary):
	self.dialogue = dialogue
	
	for signal_type in dialogue:
		var dialog: DialogData = dialogue[signal_type] as DialogData
		match signal_type:
			BattleScene.BattleDialogueSignalType.ON_BATTLE_START:
				EventBus.battle_scene_start.connect(start_dialog.bind(dialog), CONNECT_ONE_SHOT)
			BattleScene.BattleDialogueSignalType.ON_FIRST_ATTACK:
				if !on_attack_connected:
					EventBus.attack_ended.connect(post_attack_dialogue)
					on_attack_connected = true
				attack_triggers[1] = dialog
			BattleScene.BattleDialogueSignalType.ON_SECOND_ATTACK:
				if !on_attack_connected:
					EventBus.attack_ended.connect(post_attack_dialogue)
					on_attack_connected = true
				attack_triggers[2] = dialog
				
func post_attack_dialogue(attacker, _b, _c):
	if attacker.get_type() == AbstractCharacter.CharacterType.ENEMY:
		return
	player_attack_amount += 1
	if attack_triggers.has(player_attack_amount):
		await start_dialog(attack_triggers.get(player_attack_amount))

func start_dialog(dialog_data: DialogData, delay: float = 0.0):
	if delay != 0.0:
		await get_tree().create_timer(delay).timeout
	EventBus.dialog_start.emit(dialog_data)
	await EventBus.dialog_finished

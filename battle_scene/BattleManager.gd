extends Node

var all_characters: Array[AbstractCharacter]
@onready var select_manager: SelectManager = $/root/BattleField/SelectManager as SelectManager
@onready var hud_manager: HUDManager = $/root/BattleField/HUDManager as HUDManager

var current_move: int = -1

# initiative-based turn system
func _ready():
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	var allies: Array[Node] = get_tree().get_nodes_in_group("player")
	
	all_characters = []
	all_characters.append_array(enemies)
	all_characters.append_array(allies)
	all_characters.sort_custom(_sort_by_initiative)
	
	for char in all_characters:
		char.death.connect(func(x): 
			var index = all_characters.find(x)
			if index <= current_move:
				current_move -= 1
			all_characters.erase(x)
		)
	
	EventBus.attack_landed.connect(_on_attack_land)
	EventBus.battle_scene_fully_ready.connect(next_move)
	pass 

func next_move():
	current_move += 1
	if current_move >= all_characters.size():
		current_move = 0
	var char = all_characters[current_move]
	var char_type = char.get_type()
	if char_type == AbstractCharacter.CharacterType.PLAYER:
		select_manager.set_select_state(SelectManager.SelectState.PLAYER)
		hud_manager.prepare_player_attack()
		return
	if char_type == AbstractCharacter.CharacterType.ENEMY:
		var enemy = char as Enemy
		enemy.do_move(select_manager.players(), select_manager.enemies())
		return

func _sort_by_initiative(a: AbstractCharacter, b: AbstractCharacter):
	return a.initiative > b.initiative

func _on_attack_pressed():
	select_manager.mark_selected_player_moved()

func _on_attack_land(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	if attacker.get_type() == AbstractCharacter.CharacterType.PLAYER:
		var enemies_left = select_manager.enemy_amount()
		if enemies_left == 0:
			EventBus.emit_battle_scene_end()
			return
		select_manager.mark_selected_player_moved()
		if select_manager.player_moves_left() == 0:
			select_manager.reset_player_moves()
		else: 
			select_manager.select(SelectManager.Select.NEXT, true)
	else: if attacker.get_type() == AbstractCharacter.CharacterType.ENEMY:
		var players_left = select_manager.players_amount()
		if players_left == 0:
			EventBus.emit_battle_scene_end()
			return
	next_move()

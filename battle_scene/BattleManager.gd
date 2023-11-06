extends Node
class_name BattleManager

const pause_after_dialogue = 0.5

var all_characters: Array[AbstractCharacter]
@onready var select_manager: SelectManager = $"../SelectManager" as SelectManager
@onready var hud_manager: HUDManager = $"../HUDManager" as HUDManager
var enemies: Array[Node]
var allies: Array[Node]

var current_move: int = -1
var is_game_paused: bool = false
var is_move_interrupted: bool = false

func start():
	enemies = get_tree().get_nodes_in_group("enemy")
	allies = get_tree().get_nodes_in_group("player")
	
	all_characters = []
	all_characters.append_array(enemies)
	all_characters.append_array(allies)
	for char in all_characters:
		char.death.connect(func(x):
			all_characters.erase(x)
			if char.get_type() == AbstractCharacter.CharacterType.ENEMY:
				enemies.erase(x)
			else:
				allies.erase(x)
		)

	EventBus.attack_ended.connect(_on_attack_end)
	EventBus.dialog_start.connect(stop_game)
	EventBus.dialog_finished.connect(continue_game)
	pass 

func _on_attack_end(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	await _clean_dead()
	await get_tree().create_timer(0.25).timeout
	if attacker.get_type() == AbstractCharacter.CharacterType.PLAYER:
		attack.start_cooldown()
		var enemies_left = select_manager.enemy_amount()
		if enemies_left == 0:
			_finish_battle(EventBus.BattleEndType.VICTORY)
			return
			
		select_manager.mark_selected_player_moved()
		if select_manager.player_moves_left() <= 0:
			select_manager.reset_player_moves()
		else:
			select_manager.select(SelectManager.Select.NEXT, true)
		start_next_round()
		
	else: if attacker.get_type() == AbstractCharacter.CharacterType.ENEMY:
		attacker.set_enemy_thinking()
		var new_enemies = _check_for_new_enemies()
		if !new_enemies.is_empty():
			for enemy in new_enemies:
				_add_enemy(enemy)
				select_manager.add_enemy(enemy)
				hud_manager.add_enemy(enemy)
		
		var players_left = select_manager.players_amount()
		if players_left == 0:
			_finish_battle(EventBus.BattleEndType.DEFEAT)
			return
			
		if select_manager.player_moves_left() <= 0:
			select_manager.reset_player_moves()	
		next_move()

func _add_enemy(enemy: Enemy):
	enemies.append(enemy)
	all_characters.append(enemy)
	enemy.death.connect(func(x):
		all_characters.erase(x)
		enemies.erase(x)
	)

func _clean_dead():
	for char in all_characters:
		if char.is_dead:
			await char.die()

func _check_for_new_enemies():
	var _enemies = get_tree().get_nodes_in_group("enemy")
	var new_enemies = []
	for enemy in _enemies:
		if !(enemy in enemies):
			new_enemies.append(enemy)
	return new_enemies

func _finish_battle(result):
	EventBus.emit_battle_scene_fade_away(result)

func next_move():
	if is_game_paused:
		is_move_interrupted = true
		return
	for enemy in enemies:
		if !enemy.has_moved && enemy.moves_left() == 0:
			enemy.has_moved = true
			enemy.do_move(allies, enemies)
			return
	hud_manager.enable_player_movement()

func start_next_round():
	for enemy in enemies:
		enemy.has_moved = false
		if enemy.moves_left() <= 0:
			enemy.prepare_random_attack()
			continue
		enemy.decrement_time()
	for player in allies:
		player.decrement_attack_cooldown()
	next_move()
	
		
func stop_game(_a):
	is_game_paused = true

func continue_game():
	is_game_paused = false
	if is_move_interrupted:
		is_move_interrupted = false
		await get_tree().create_timer(pause_after_dialogue).timeout
		next_move()
	

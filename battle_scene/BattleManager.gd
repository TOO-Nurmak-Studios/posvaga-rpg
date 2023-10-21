extends Node

var all_characters: Array[AbstractCharacter]
@onready var select_manager: SelectManager = $"../SelectManager" as SelectManager
@onready var hud_manager: HUDManager = $"../HUDManager" as HUDManager
var enemies: Array[Node]
var allies: Array[Node]

var current_move: int = -1

# initiative-based turn system
func _ready():
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
	$"..".ready.connect(_on_battle_scene_ready)
	pass 

func _on_battle_scene_ready():
	get_tree().create_timer(1).timeout.connect(start_next_round)

func start_next_round():
	for enemy in enemies:
		enemy.has_moved = false
		if enemy.moves_left() <= 0:
			enemy.prepare_random_attack()
			continue
		enemy.decrement_time()
	next_move()

func next_move():
	for enemy in enemies:
		if !enemy.has_moved && enemy.moves_left() == 0:
			enemy.has_moved = true
			enemy.do_move(allies, enemies)
			return

	hud_manager.enable_player_movement()

func _on_attack_pressed():
	select_manager.mark_selected_player_moved()

func _on_attack_end(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	await _clean_dead()
	if attacker.get_type() == AbstractCharacter.CharacterType.PLAYER:
		var enemies_left = select_manager.enemy_amount()
		if enemies_left == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			EventBus.emit_battle_scene_end()
			return
		select_manager.mark_selected_player_moved()
		if select_manager.player_moves_left() <= 0:
			select_manager.reset_player_moves()
		else:
			select_manager.select(SelectManager.Select.NEXT, true)
		start_next_round()
	else: if attacker.get_type() == AbstractCharacter.CharacterType.ENEMY:
		attacker.set_enemy_thinking()
		var players_left = select_manager.players_amount()
		if players_left == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			EventBus.emit_battle_scene_end()
			return
		if select_manager.player_moves_left() <= 0:
			select_manager.reset_player_moves()	
		next_move()

func _clean_dead():
	for char in all_characters:
		if char.is_dead:
			await char.die()

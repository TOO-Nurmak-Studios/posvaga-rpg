class_name SelectManager
extends Node

var chars: Dictionary # <CharType, Array[AbstractCharacter]>
var selected_char_index: Dictionary # <CharType, int>

var moved_players: Array[AbstractCharacter]

enum Select {NEXT, PREV}
enum SelectState {DISABLED, ENEMY, PLAYER}
enum CharType {ENEMY, PLAYER}
var select_state: SelectState

signal player_selected(player: AbstractCharacter)

func start():
	_init_chars()
	
	set_select_state(SelectState.DISABLED)
	pass 

func _init_chars():
	selected_char_index[CharType.ENEMY] = -1
	selected_char_index[CharType.PLAYER] = -1
	moved_players = []
	chars[CharType.ENEMY] = get_tree().get_nodes_in_group("enemy")
	chars[CharType.PLAYER] = get_tree().get_nodes_in_group("player")
	for ch in chars[CharType.ENEMY]: 
		ch.death.connect(remove_enemy)
	for ch in chars[CharType.PLAYER]: 
		ch.death.connect(remove_player)
	
	select_state = SelectState.PLAYER
	select_next()
	select_state = SelectState.ENEMY
	select_next()
	
func select_next():
	select(Select.NEXT)
	
func select_prev():
	select(Select.PREV)
					

func select(select_type: Select, force: bool = false, force_type: SelectState = SelectState.DISABLED):
	if select_state == SelectState.DISABLED && !force:
		return
	
	var modifier: int = 1 if select_type == Select.NEXT else -1
	var cur_select_state = force_type if force else select_state
	
	var char_type = CharType.ENEMY if cur_select_state == SelectState.ENEMY else CharType.PLAYER
	var is_player = (char_type == CharType.PLAYER)

	if is_player && moved_players.size() == players().size() && !force:
		print("trying to select char while all chars already did their move")
		return
	
	# remove highlight from currently selected character
	if selected_char_index[char_type] != -1:
		chars[char_type][selected_char_index[char_type]].unselect()
		
	# if no-one to select - return	
	if chars[char_type].size() == 0:
		return
		
	# traverse through character list until we find non-moved character	
	var index_of_selected = selected_char_index[char_type]
	while true:
		# i need do..while but gdscript does not support it
		# increment index of selected char
		index_of_selected += modifier
		# loop char array
		if index_of_selected >= chars[char_type].size():
			index_of_selected = 0
		if index_of_selected < 0:
			index_of_selected = chars[char_type].size() - 1
		if !is_player || force || !moved_players.has(players()[index_of_selected]):
			break	
			
	# we selected a character	
	selected_char_index[char_type] = index_of_selected
	
	# sometimes we just want to move selection but without highlighting
	if select_state != SelectState.DISABLED:
		chars[char_type][selected_char_index[char_type]].select()
		
	# emit player selection
	if char_type == CharType.PLAYER:
		player_selected.emit(selected_player())

func add_enemy(enemy: Enemy):
	enemies().push_back(enemy)
	enemy.death.connect(remove_enemy)

func remove_enemy(enemy: Enemy):
	if enemy == selected_enemy():
		select(Select.NEXT, true, SelectState.ENEMY)
		
	var index = enemies().find(enemy)
	if index <= selected_char_index[CharType.ENEMY]:
		selected_char_index[CharType.ENEMY] -= 1
		
	enemies().erase(enemy)

func remove_player(player: AbstractCharacter):
	if player == selected_player():
		select(Select.NEXT, true, SelectState.PLAYER)
		
	var index = players().find(player)
	if index <= selected_char_index[CharType.PLAYER]:
		selected_char_index[CharType.PLAYER] -= 1
		
	players().erase(player)
	moved_players.erase(player)

func on_shoot_pressed(attack: Attack):
	selected_player().attack(attack, selected_enemy())
	
func set_select_state(new_state: SelectState):
	select_state = new_state
	match new_state:
		SelectState.DISABLED:
			if selected_enemy() != null:
				selected_enemy().unselect()
			if selected_player() != null:
				selected_player().unselect()
		SelectState.ENEMY:
			if selected_enemy() != null:
				selected_enemy().select()
			if selected_player() != null:
				selected_player().unselect()
		SelectState.PLAYER:
			if selected_player() != null:
				if moved_players.has(selected_player()):
					select(Select.NEXT)
				selected_player().select()
			if selected_enemy() != null:
				selected_enemy().unselect()	

func selected_player() -> AbstractCharacter:
	#return selected_char[CharType.PLAYER]
	if selected_char_index[CharType.PLAYER] == -1:
		return null
	return players()[selected_char_index[CharType.PLAYER]]

func mark_selected_player_moved():
	moved_players.push_back(selected_player())
	
func player_moves_left() -> int:
	return player_amount() - moved_players.size()
	
func reset_player_moves():
	moved_players.clear()
	
func player_amount() -> int:
	return players().size()
	
func players() -> Array[Node]:
	return chars[CharType.PLAYER]

func players_amount() -> int:
	return players().size()
	
func enemies() -> Array[Node]:
	return chars[CharType.ENEMY]

func enemy_amount() -> int:
	return enemies().size()
	
func selected_enemy() -> Enemy:
	#return selected_char[CharType.ENEMY]
	if selected_char_index[CharType.ENEMY] == -1:
		return null
	return enemies()[selected_char_index[CharType.ENEMY]]

class_name BattleManager
extends Node

var chars: Dictionary # <CharType, Array[AbstractCharacter]>
var selected_char: Dictionary # <CharType, AbstractCharacter>
var selected_char_index: Dictionary # <CharType, int>

enum Select {NEXT, PREV}
enum SelectState {DISABLED, ENEMY, PLAYER}
enum CharType {ENEMY, PLAYER}
var select_state: SelectState

signal player_selected(player: Player)

func _ready():
	selected_char_index[CharType.ENEMY] = -1
	selected_char_index[CharType.PLAYER] = -1
	selected_char[CharType.ENEMY] = null
	selected_char[CharType.PLAYER] = null
	chars[CharType.ENEMY] = get_tree().get_nodes_in_group("enemy")
	chars[CharType.PLAYER] = get_tree().get_nodes_in_group("player")
	for ch in chars[CharType.ENEMY]: 
		ch.death.connect(remove_enemy)
	for ch in chars[CharType.PLAYER]: 
		ch.death.connect(remove_player)
		
		
	EventBus.select_next_button_pressed.connect(_select_next)
	EventBus.select_prev_button_pressed.connect(_select_prev)
	
	select_state = SelectState.PLAYER
	_select_next()
	select_state = SelectState.ENEMY
	_select_next()
	set_select_state(SelectState.PLAYER)
	pass 
	
	
func _select_next():
	select(Select.NEXT)
	
func _select_prev():
	select(Select.PREV)
					

func select(select_type: Select, force: bool = false, force_type: SelectState = SelectState.DISABLED):
	if select_state == SelectState.DISABLED && !force:
		return
	
	var modifier: int = 1 if select_type == Select.NEXT else -1
	var cur_select_state = force_type if force else select_state
	
	var char_type = CharType.ENEMY if cur_select_state == SelectState.ENEMY else CharType.PLAYER
	
	if selected_char[char_type] != null:
		selected_char[char_type].unselect()
	selected_char_index[char_type] += 1
	if selected_char_index[char_type] >= chars[char_type].size():
		selected_char_index[char_type] = 0
	var index = selected_char_index[char_type]
	selected_char[char_type] = chars.get(char_type)[index]
	if select_state != SelectState.DISABLED:
		selected_char[char_type].select()
	if char_type == CharType.PLAYER:
		player_selected.emit(selected_player())

func remove_enemy(enemy: Enemy):
	if enemy == selected_enemy():
		select(Select.NEXT, true, SelectState.ENEMY)
	chars[CharType.ENEMY].erase(enemy)

func remove_player(player: Player):
	if player == selected_player():
		select(Select.NEXT, true, SelectState.PLAYER)
	chars[CharType.PLAYER].erase(player)

func on_shoot_pressed(attack_index: int):
	selected_player().attack(attack_index, selected_enemy())
	
func set_select_state(new_state: SelectState):
	select_state = new_state
	match new_state:
		SelectState.DISABLED:
			if selected_enemy() != null:
				selected_enemy().unselect()
		SelectState.ENEMY:
			if selected_enemy() != null:
				selected_enemy().select()
			if selected_player() != null:
				selected_player().unselect()
		SelectState.PLAYER:
			if selected_enemy() != null:
				selected_enemy().unselect()
			if selected_player() != null:
				selected_player().select()

func selected_player() -> Player:
	return selected_char[CharType.PLAYER]

func selected_enemy():
	return selected_char[CharType.ENEMY]
	

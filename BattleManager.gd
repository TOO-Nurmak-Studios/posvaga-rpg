class_name BattleManager
extends Node

var player: TestPlayer
var enemy_chars: Array[Node]
var selected: TestCharacter
var selected_index: int = -1

enum Select {NEXT, PREV}

var _is_select_toggled = true

func _ready():
	
	player = get_tree().get_first_node_in_group("player")
	
	enemy_chars = get_tree().get_nodes_in_group("enemy")
	for ch in enemy_chars: 
		var enemy_char: TestCharacter = ch as TestCharacter
		enemy_char.death.connect(remove_enemy)
		
	select(Select.NEXT)
	disable_select()
	pass 

func select(select_type: Select, force: bool = false):
	if !_is_select_toggled && !force:
		return
	
	var modifier: int = 1 if select_type == Select.NEXT else -1
	
	if selected != null:
		selected.unselect()
	selected_index += 1
	if selected_index >= enemy_chars.size():
		selected_index = 0
	selected = enemy_chars[selected_index]
	if _is_select_toggled:
		selected.select()

func remove_enemy(enemy: TestCharacter):
	if enemy == selected:
		select(Select.NEXT, true)
	enemy_chars.erase(enemy)

func on_shoot_pressed():
	player.shoot(selected)

func enable_select():
	_is_select_toggled = true
	if selected != null:
		selected.select()
	
func disable_select():
	_is_select_toggled = false
	if selected != null:	
		selected.unselect()

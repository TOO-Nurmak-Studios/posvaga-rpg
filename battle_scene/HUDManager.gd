class_name HUDManager

extends Node

#constants
const attack_container_offset = Vector2(16, -8)

#resources
var health_bar_scene: Resource = preload("res://battle_scene/HUD/HealthBar.tscn")
var timer_scene: Resource = preload("res://battle_scene/HUD/MoveTimer.tscn")
var button_scene: PackedScene = preload("res://battle_scene/HUD/KeyboardButton.tscn")
var container_scene: PackedScene = preload("res://battle_scene/HUD/AttackContainer.tscn")

var font: Resource = preload("res://fonts/monogram-extended.ttf")

# used nodes
var main_scene: Node
var attack_containers: Dictionary # <Player, AttackContainer>
var current_attack_container: AttackContainer
var inventory_container: AttackContainer
var tooltip_label: Label
var attack_label: Label
@onready var select_manager: SelectManager = $"../SelectManager" as SelectManager

# state machine
enum State {SELECT_PLAYER, SELECT_ATTACK, SELECT_ENEMY, SELECT_ALLY, SELECT_ITEM, NOTHING}
var was_movement_disabled: bool	= false
var current_state: State = State.NOTHING
var previous_state: State = State.NOTHING
var selected_attack: Attack

var current_character: AbstractCharacter

# must be called after battle manager and select manager! 
func start():
	main_scene = get_parent()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	_create_attack_menu(select_manager.selected_player())
	_flip_enemies()
	_create_tooltip_label()
	_create_attack_label()
	_create_health_bars()
	_create_move_timers()

	EventBus.action_button_pressed.connect(_action_pressed)
	EventBus.action_back_button_pressed.connect(_action_back_pressed)
	EventBus.battle_scene_fade_away.connect(_on_battle_scene_fade_away)
	EventBus.battle_scene_end.connect(_on_battle_scene_end)
	EventBus.attack_ended.connect(_draw_attack_line)
	EventBus.select_next_button_pressed.connect(_select_next)
	EventBus.select_prev_button_pressed.connect(_select_prev)
	EventBus.select_left_button_pressed.connect(_select_left)
	EventBus.select_right_button_pressed.connect(_select_right)
	EventBus.dialog_start.connect(disable_player_movement)
	EventBus.dialog_finished.connect(enable_player_movement_dialog)
	
	select_manager.player_selected.connect(_create_attack_menu)
	
func _select_next():
	if current_state == State.SELECT_ATTACK:
		current_attack_container.select_next_button(AttackContainer.Select.NEXT)
		return
	if current_state == State.SELECT_ITEM:
		inventory_container.select_next_button(AttackContainer.Select.NEXT)
		return
	select_manager.select_next()

func _select_prev():
	if current_state == State.SELECT_ATTACK:
		current_attack_container.select_next_button(AttackContainer.Select.PREV)
		return
	if current_state == State.SELECT_ITEM:
		inventory_container.select_next_button(AttackContainer.Select.PREV)
		return
	select_manager.select_prev()
	
func _select_left():
	if current_state == State.SELECT_ATTACK:
		change_state(State.SELECT_PLAYER)
	
func _select_right():
	if current_state == State.SELECT_PLAYER:
		change_state(State.SELECT_ATTACK)
		
func _attack_ended(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	_draw_attack_line(attacker, attacked, attack)

func _draw_attack_line(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	if attack != null:
		var attacked_str = ", ".join(attacked.map(func(a): return a.char_name))
		attack_label.text = attack.attack_postmessage.format({
				"attacker": attacker.char_name, 
				"attacked": attacked_str, 
				"damage": attacked.reduce(func(accum, char): return accum + char.health.last_damage, 0)
			})
		attack_label.show()

func add_enemy(enemy: Enemy):
	_create_health_bar(enemy.health)
	_create_move_timer(enemy)

func _on_battle_scene_fade_away(_unused):
	change_state(State.NOTHING)
	tooltip_label.text = "Battle finished!"
	tooltip_label.show()

func _on_battle_scene_end(_unused):
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _action_pressed():
	if current_state == State.SELECT_ENEMY:
		select_manager.on_shoot_pressed(selected_attack)
		change_state(State.NOTHING)
	elif current_state == State.SELECT_ATTACK:
		current_attack_container.selected_button().pressed.emit()
	elif current_state == State.SELECT_ITEM:
		inventory_container.selected_button().pressed.emit()
	return	

func _action_back_pressed():
	if current_state == State.SELECT_ENEMY:
		change_state(State.SELECT_PLAYER)
	return	
	
func _attack_pressed(i: int):
	var attack = select_manager.selected_player().attacks[i]
	selected_attack = attack
	_process_selected_attack()

func _item_pressed(item: Item):
	ItemsManager.get_current_inventory().remove(item.id)
	selected_attack = select_manager.selected_player().available_item_attacks[item.id]
	_process_selected_attack()

func _close_inventory():
	change_state(State.SELECT_PLAYER)

func _process_selected_attack():
	if selected_attack.attack_type == Attack.AttackType.INVENTORY_OPEN:
		change_state(State.SELECT_ITEM)
		tooltip_label.text = selected_attack.attack_tooltip
		return
	if selected_attack.attack_type == Attack.AttackType.SINGLE:
		change_state(State.SELECT_ENEMY)
		tooltip_label.text = selected_attack.attack_tooltip
		return
	if selected_attack.attack_type == Attack.AttackType.ON_SELF:
		select_manager.on_shoot_pressed(selected_attack)
		change_state(State.NOTHING)
		return
		
func disable_player_movement(_a):
	if current_state == State.SELECT_PLAYER:
		print("disable_player_movement_dialog")
		change_state(State.NOTHING)
		was_movement_disabled = true

func enable_player_movement_dialog():
	if was_movement_disabled:
		print("enable_player_movement_dialog")
		change_state(State.SELECT_PLAYER)
		was_movement_disabled = false

func enable_player_movement():
	print("enable_player_movement")
	change_state(State.SELECT_PLAYER)
	
func change_state(state: State):
	previous_state = current_state
	match state:
		State.SELECT_ITEM:
			current_state = State.SELECT_ITEM
			select_manager.set_select_state(SelectManager.SelectState.DISABLED)
			current_attack_container.hide()
			tooltip_label.show()
			_create_inventory_menu()
			inventory_container.enable()
			return
		State.SELECT_ATTACK:
			current_state = State.SELECT_ATTACK
			select_manager.set_select_state(SelectManager.SelectState.DISABLED)
			current_attack_container.enable()
			tooltip_label.hide()
			return
		State.SELECT_PLAYER:
			current_state = State.SELECT_PLAYER
			select_manager.set_select_state(SelectManager.SelectState.PLAYER)
			_create_attack_menu(select_manager.selected_player())
			current_attack_container.disable()
			if inventory_container != null:
				inventory_container.hide()
			tooltip_label.hide()
			return
		State.SELECT_ENEMY:
			current_state = State.SELECT_ENEMY
			select_manager.set_select_state(SelectManager.SelectState.ENEMY)
			current_attack_container.hide()
			if inventory_container != null:
				inventory_container.hide()
			tooltip_label.show()
			return
		State.NOTHING:
			current_state = State.NOTHING
			selected_attack = null
			select_manager.set_select_state(SelectManager.SelectState.DISABLED)
			if current_attack_container != null:
				current_attack_container.hide()
			if inventory_container != null:
				inventory_container.hide()
			if tooltip_label != null:
				tooltip_label.hide()
			return
			
func _flip_enemies():
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var sprite: AnimatedSprite2D = enemy.get_node("Sprite") as AnimatedSprite2D
		#sprite.flip_h = true

func _create_move_timers():
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		_create_move_timer(enemy)

func _create_move_timer(enemy: Enemy):
	var timer: MoveTimer = timer_scene.instantiate()
	enemy.move_timer = timer

	var node = Node2D.new()
	var position: Vector2 = Vector2(0, -40) * enemy.scale
	node.position = position

	enemy.tree_exiting.connect(node.queue_free)
	node.add_child.call_deferred(timer)
	main_scene.add_child.call_deferred(node)
	timer.tree_entered.connect(func(): _attach_child_remote_transform(node, enemy))

func _create_health_bars():
	var health_nodes: Array[Node] = get_tree().get_nodes_in_group("health_node")
	for health_node in health_nodes:
		_create_health_bar(health_node)
		
func _create_health_bar(health_node: HealthNode):
	var hp_bar: HealthBar = health_bar_scene.instantiate()
	hp_bar.value = health_node.health
	hp_bar.max_value = health_node.health
	health_node.health_changed.connect(hp_bar.update_value)
	health_node.tree_exiting.connect(hp_bar.queue_free)
	health_node.health_bar = hp_bar
		
	var node = Node2D.new()
	var parent_position: Vector2 = health_node.global_position
	node.position = parent_position
		
	node.add_child.call_deferred(hp_bar)
	main_scene.add_child.call_deferred(node)
	hp_bar.tree_entered.connect(_attach_sibling_remote_transform.bind(node, health_node))
		
	
func _attach_sibling_remote_transform(transformed_node: Node, sibling_node: Node2D):
	var rt: RemoteTransform2D = RemoteTransform2D.new()
	rt.position = sibling_node.position
	rt.remote_path = transformed_node.get_path()
	rt.update_rotation = false
	#rt.update_scale = false
	sibling_node.add_sibling(rt)
	
func _attach_child_remote_transform(transformed_node: Node, parent_node: Node2D):
	var rt: RemoteTransform2D = RemoteTransform2D.new()
	rt.position = transformed_node.position
	rt.remote_path = transformed_node.get_path()
	rt.update_rotation = false
	rt.update_scale = false
	parent_node.add_child(rt)

func _create_tooltip_label():
	tooltip_label = Label.new()
	tooltip_label.z_index = 4
	tooltip_label.add_theme_font_size_override("font_size", 16)
	tooltip_label.add_theme_font_override("font", font)
	tooltip_label.text = "Use arrows to select enemy, Enter to attack."
	tooltip_label.position = Vector2(8, 8)
	tooltip_label.hide()
	add_sibling.call_deferred(tooltip_label)
	
func _create_attack_label():
	attack_label = Label.new()
	attack_label.z_index = 4
	attack_label.add_theme_font_size_override("font_size", 16)
	attack_label.add_theme_font_override("font", font)
	attack_label.text = ""
	attack_label.position = Vector2(8, 28)
	attack_label.hide()
	add_sibling.call_deferred(attack_label)

func _calc_container_position() -> Vector2:
	var sprite = current_character.get_node("Sprite") as AnimatedSprite2D
	var global_pos = sprite.global_position
	var rect2size = sprite.sprite_frames.get_frame_texture("idle", 0).get_size() * sprite.scale * current_character.scale
	return global_pos + Vector2(rect2size.x / 2, 0) + attack_container_offset

func _create_inventory_menu():
	if select_manager.select_state == SelectManager.SelectState.DISABLED:
		if current_state != State.SELECT_ITEM:
			return
		
	var inventory: Inventory = ItemsManager.get_current_inventory()
	
	if inventory_container != null:
		inventory_container.hide()
		if inventory_container.buttons.size() != inventory.size():
			inventory_container.queue_free()
		else:
			inventory_container.show()
			return
	
	var inventory_menu_position = _calc_container_position()
	
	inventory_container = container_scene.instantiate() as AttackContainer
	inventory_container.position = inventory_menu_position
	inventory_container.button_selected.connect(func(i): 
		item_in_container_selected(inventory_container, i)
	)
	
	var button_children = []
	
	var items = inventory.items
	for item_id in items:
		var stack: ItemsStack = items[item_id]
		var item: Item = stack.example_item
		var button: KeyboardButton = button_scene.instantiate() as KeyboardButton
		button.init_vars(item.item_name, 16)
		button.scale = Vector2(1, 2) 
		button.pressed.connect(_item_pressed.bind(item))
		button.add_theme_font_override("font", font)
		button.add_to_group("button")
		button_children.append(button)
	
	var back_button: KeyboardButton = button_scene.instantiate() as KeyboardButton
	back_button.init_vars("Назад", 16)
	back_button.scale = Vector2(1, 2) 
	back_button.pressed.connect(_close_inventory.bind())
	back_button.add_theme_font_override("font", font)
	back_button.add_to_group("button")
	button_children.append(back_button)
	
	inventory_container.init(button_children)
	add_sibling.call_deferred(inventory_container)
	inventory_container.ready.connect(on_inventory_container_ready)

func _create_attack_menu(character: AbstractCharacter):
	current_character = character
	if select_manager.select_state == SelectManager.SelectState.DISABLED:
		return
	if current_attack_container != null:
		current_attack_container.hide()
	if attack_containers.has(character):
		if attack_containers[character].buttons.size() != character.attacks.size():
			attack_containers[character].queue_free()
		else:
			current_attack_container = attack_containers[character]
			current_attack_container.show()
			return
	
	var attack_menu_position = _calc_container_position()
	
	current_attack_container = container_scene.instantiate() as AttackContainer
	current_attack_container.position = attack_menu_position
	current_attack_container.button_selected.connect(func(i): 
		attack_in_container_selected(current_attack_container, character.attacks[i])
		)
	var button_children = []
	
	for i in range(character.attacks.size()):
		var attack = character.attacks[i]
		var button: KeyboardButton = button_scene.instantiate() as KeyboardButton
		button.init_vars(attack.attack_name, 16)
		button.scale = Vector2(1, 2) 
		button.pressed.connect(_attack_pressed.bind(i))
		attack.cooldown_update.connect(button.disable_button)
		attack.cooldown_end.connect(button.enable_button)
		button.add_theme_font_override("font", font)
		button.add_to_group("button")
		if attack._cooldown != 0:
			button.disable_button(attack._cooldown)
		button_children.append(button)
		#current_attack_container.button_container.add_child.call_deferred(button)
	
	current_attack_container.init(button_children)
	add_sibling.call_deferred(current_attack_container)
	current_attack_container.ready.connect(fit_container_deferred.bind(current_attack_container))
	attack_containers[character] = current_attack_container

func item_in_container_selected(container: AttackContainer, i: int):
	var buttons_size = inventory_container.buttons.size()
	
	if i == buttons_size - 1:
		# last is back
		container.label.text = str("Закрыть инвентарь.")
		return
	
	var items = ItemsManager.get_current_items()
	var stack: ItemsStack = items.get(items.keys()[i])
	var item: Item = stack.example_item
	container.label.text = str(item.item_name, "\n", item.description, "\n", stack.count, " шт.\n")

func attack_in_container_selected(container: AttackContainer, attack: Attack):
	container.label.text = str(attack.attack_name, "\n", attack.attack_description, "\n")

func on_inventory_container_ready():
	fit_container_deferred(inventory_container)
	_select_next()

func fit_container_deferred(container: AttackContainer):
	container.fit_container.call_deferred()

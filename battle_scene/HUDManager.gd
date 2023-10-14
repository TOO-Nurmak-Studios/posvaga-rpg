class_name HUDManager

extends Node

#resources
var health_bar_scene: Resource = preload("res://battle_scene/HUD/HealthBar.tscn")
var timer_scene: Resource = preload("res://battle_scene/HUD/MoveTimer.tscn")

# used nodes
var main_scene: Node
var attack_containers: Dictionary
var current_attack_container: Container
var tooltip_label: Label
var attack_label: Label
@onready var select_manager: SelectManager = $/root/BattleField/SelectManager as SelectManager

# state machine
enum State {SELECT_ATTACK, SELECT_ENEMY, NOTHING}
var current_state: State = State.SELECT_ATTACK
var selected_attack: int = -1

# must be called after battle manager! 
func _ready():
	main_scene = get_parent()
	
	_create_attack_menu(select_manager.selected_player())
	_flip_enemies()
	_create_tooltip_label()
	_create_attack_label()
	_create_health_bars()
	_create_move_timers()
	
	EventBus.action_button_pressed.connect(_action_pressed)
	EventBus.battle_scene_end.connect(_on_battle_scene_end)
	select_manager.player_selected.connect(_create_attack_menu)
	EventBus.attack_ended.connect(_draw_attack_line)
	
func _draw_attack_line(attacker: AbstractCharacter, attacked: Array[AbstractCharacter], attack: Attack):
	if attack != null:
		var attacked_str = ", ".join(attacked.map(func(a): return a.char_name))
		attack_label.text = attack.attack_postmessage % [attacker.char_name, attacked_str]
		attack_label.show()
	

func _on_battle_scene_end():
	change_state(State.NOTHING)
	tooltip_label.text = "Battle finished!"
	tooltip_label.show()	

func _action_pressed():
	if current_state == State.SELECT_ENEMY:
		select_manager.on_shoot_pressed(selected_attack)
		change_state(State.NOTHING)
	return	

func _attack_pressed(i: int):
	change_state(State.SELECT_ENEMY)
	selected_attack = i

func enable_player_movement():
	change_state(State.SELECT_ATTACK)
	
func change_state(state: State):
	match state:
		State.SELECT_ATTACK:
			current_state = State.SELECT_ATTACK
			select_manager.set_select_state(SelectManager.SelectState.PLAYER)
			_create_attack_menu(select_manager.selected_player())
			tooltip_label.hide()
			return
		State.SELECT_ENEMY:
			current_state = State.SELECT_ENEMY
			select_manager.set_select_state(SelectManager.SelectState.ENEMY)
			current_attack_container.hide()
			tooltip_label.show()
			return
		State.NOTHING:
			current_state = State.NOTHING
			selected_attack = -1
			select_manager.set_select_state(SelectManager.SelectState.DISABLED)
			if current_attack_container != null:
				current_attack_container.hide()
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
		health_node = health_node as HealthNode
		
		var hp_bar: HealthBar = health_bar_scene.instantiate()
		hp_bar.update_value(0, health_node.health)
		health_node.health_changed.connect(hp_bar.update_value)
		health_node.tree_exiting.connect(hp_bar.queue_free)
		
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
	#rt.update_scale = false
	parent_node.add_child(rt)
		
func _create_tooltip_label():
	tooltip_label = Label.new()
	tooltip_label.add_theme_font_size_override("font_size", 16)
	tooltip_label.text = "Use arrows to select enemy, Enter to attack."
	tooltip_label.position = Vector2(8, 8)
	tooltip_label.hide()
	add_sibling.call_deferred(tooltip_label)
	
func _create_attack_label():
	attack_label = Label.new()
	attack_label.add_theme_font_size_override("font_size", 16)
	attack_label.text = ""
	attack_label.position = Vector2(8, 24)
	attack_label.hide()
	add_sibling.call_deferred(attack_label)
	
func _create_attack_menu(character: Player):
	if select_manager.select_state == SelectManager.SelectState.DISABLED:
		return
	if current_attack_container != null:
		current_attack_container.hide()
	if attack_containers.has(character):
		current_attack_container = attack_containers[character]
		current_attack_container.show()
		return
	
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	var global_pos = sprite.global_position
	var rect2size = sprite.sprite_frames.get_frame_texture("shoot", 0).get_size() * sprite.scale * character.scale
	var attack_menu_position = global_pos + Vector2(rect2size.x / 2, 0) + Vector2(4, -8)
	
	current_attack_container = VBoxContainer.new()
	current_attack_container.position = attack_menu_position
	
	for i in range(character.attacks.size()):
		var attack = character.attacks[i]
		var button: Button = Button.new()
		button.scale = Vector2(1, 1) 
		button.text = attack.attack_name
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(func(): _attack_pressed(i))
		current_attack_container.add_child(button)
	
	add_sibling.call_deferred(current_attack_container)
	attack_containers[character] = current_attack_container

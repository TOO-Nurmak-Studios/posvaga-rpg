class_name HUDManager

extends Node

#resources
var health_bar_scene: Resource = preload("res://HUD/HealthBar.tscn")

# used nodes
var main_scene: Node
var attack_containers: Dictionary
var current_attack_container: Container
var tooltip_label: Label
@onready var battle_manager: BattleManager = $/root/Field/BattleManager as BattleManager

# state machine
enum State {SELECT_ATTACK, SELECT_ENEMY, NOTHING}
@export var current_state: State = State.SELECT_ATTACK
var selected_attack: int = -1

# must be called after battle manager! 
func _ready():
	main_scene = get_parent()
	
	_create_attack_menu(battle_manager.selected_player())
	_create_tooltip_label()
	_create_health_bars()
	
	EventBus.action_button_pressed.connect(action_pressed)
	EventBus.player_attack_landed.connect(back_to_default_state)
	battle_manager.player_selected.connect(_create_attack_menu)
	

func action_pressed():
	if current_state == State.SELECT_ENEMY:
		battle_manager.on_shoot_pressed(selected_attack)
		change_state(State.NOTHING)
	return	

func attack_pressed(i: int):
	change_state(State.SELECT_ENEMY)
	selected_attack = i

func back_to_default_state(_attack: Attack):
	change_state(State.SELECT_ATTACK)
	
func change_state(state: State):
	match state:
		State.SELECT_ATTACK:
			current_state = State.SELECT_ATTACK
			battle_manager.set_select_state(BattleManager.SelectState.PLAYER)
			current_attack_container.show()
			tooltip_label.hide()
			return
		State.SELECT_ENEMY:
			current_state = State.SELECT_ENEMY
			battle_manager.set_select_state(BattleManager.SelectState.ENEMY)
			current_attack_container.hide()
			tooltip_label.show()
			return
		State.NOTHING:
			current_state = State.NOTHING
			selected_attack = -1
			battle_manager.set_select_state(BattleManager.SelectState.DISABLED)
			current_attack_container.hide()
			tooltip_label.hide()
			return
			
func _create_health_bars():
	var health_nodes: Array[Node] = get_tree().get_nodes_in_group("health_node")
	for health_node in health_nodes:
		health_node = health_node as HealthNode
		
		var hp_bar: HealthBar = health_bar_scene.instantiate()
		hp_bar.update_value(0, health_node.health)
		health_node.health_changed.connect(hp_bar.update_value)
		health_node.zero_health.connect(hp_bar.queue_free)
		
		var node = Node2D.new()
		var parent_position: Vector2 = health_node.global_position
		node.position = parent_position
		
		node.add_child.call_deferred(hp_bar)
		main_scene.add_child.call_deferred(node)
		hp_bar.tree_entered.connect(func(): _attach_remote_transform(node, health_node))
	
func _attach_remote_transform(transformed_node: Node, sibling_node: Node2D):
	var rt: RemoteTransform2D = RemoteTransform2D.new()
	rt.position = sibling_node.position
	rt.remote_path = transformed_node.get_path()
	rt.update_rotation = false
	sibling_node.add_sibling(rt)
	
func _create_tooltip_label():
	tooltip_label = Label.new()
	tooltip_label.add_theme_font_size_override("font_size", 24)
	tooltip_label.text = "Use arrows to select enemy, Enter to attack."
	tooltip_label.position = Vector2(10, 10)
	tooltip_label.hide()
	add_sibling.call_deferred(tooltip_label)
	
	
func _create_attack_menu(character: Player):
	if battle_manager.select_state == BattleManager.SelectState.DISABLED:
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
	var attack_menu_position = global_pos + Vector2(rect2size.x / 2, 0) + Vector2(10, -20)
	
	current_attack_container = VBoxContainer.new()
	current_attack_container.position = attack_menu_position
	
	for i in range(character.attacks.size()):
		var attack = character.attacks[i]
		var button: Button = Button.new()
		button.scale = Vector2(2, 2) 
		button.text = attack.attack_name
		button.add_theme_font_size_override("font_size", 24)
		button.pressed.connect(func(): attack_pressed(i))
		current_attack_container.add_child(button)
	
	add_sibling.call_deferred(current_attack_container)
	attack_containers[character] = current_attack_container

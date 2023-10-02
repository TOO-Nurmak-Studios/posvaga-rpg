class_name HUDManager

extends Node

var health_bar_scene: Resource = preload("res://HUD/HealthBar.tscn")
var main_scene: Node
@onready var battle_manager: BattleManager = $/root/Field/BattleManager as BattleManager
var player: TestPlayer

enum State {SELECT_ATTACK, SELECT_ENEMY, NOTHING}
@export var current_state: State = State.SELECT_ATTACK
var attack_container: Container
var tooltip_label: Label

func _ready():
	main_scene = get_parent()
	
	player = get_tree().get_first_node_in_group("player") as TestPlayer
	_create_attack_menu(player)
	
	_create_health_bars()
	
	EventBus.action_button_pressed.connect(action_pressed)
	EventBus.player_projectile_landed.connect(back_to_default_state)

func action_pressed():
	if current_state == State.SELECT_ENEMY:
		battle_manager.on_shoot_pressed()
		change_state(State.NOTHING)
	return	

func attack_pressed():
	change_state(State.SELECT_ENEMY)

func back_to_default_state():
	change_state(State.SELECT_ATTACK)
	
func change_state(state: State):
	match state:
		State.SELECT_ATTACK:
			current_state = State.SELECT_ATTACK
			battle_manager.disable_select()
			attack_container.show()
			tooltip_label.hide()
			return
		State.SELECT_ENEMY:
			current_state = State.SELECT_ENEMY
			battle_manager.enable_select()
			attack_container.hide()
			tooltip_label.show()
			return
		State.NOTHING:
			current_state = State.NOTHING
			battle_manager.disable_select()
			attack_container.hide()
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
		var parent_position: Vector2 = health_node.get_parent().position
		parent_position.x -= 150
		parent_position.y -= 260
		node.position = parent_position
		
		node.add_child.call_deferred(hp_bar)
		main_scene.add_child.call_deferred(node)
		hp_bar.tree_entered.connect(func(): _attach_remote_transform(node, health_node))
	
func _attach_remote_transform(transformed_node: Node, sibling_node: Node):
	var rt: RemoteTransform2D = RemoteTransform2D.new()
	rt.remote_path = transformed_node.get_path()
	rt.update_rotation = false
	sibling_node.add_sibling(rt)

func _create_attack_menu(character: TestPlayer):
	
	tooltip_label = Label.new()
	tooltip_label.add_theme_font_size_override("font_size", 24)
	tooltip_label.text = "Use arrows to select enemy, Enter to attack."
	tooltip_label.position = Vector2(10, 10)
	tooltip_label.hide()
	
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	var global_pos = sprite.global_position
	var rect2size = sprite.sprite_frames.get_frame_texture("shoot", 0).get_size() * character.scale
	var attack_menu_position = global_pos + Vector2(rect2size.x / 2, 0) + Vector2(10, -20)
	
	attack_container = VBoxContainer.new()
	attack_container.position = attack_menu_position
	
	var button: Button = Button.new()
	button.scale = Vector2(2, 2) 
	button.text = "Attack!"
	button.add_theme_font_size_override("font_size", 24)
	button.pressed.connect(attack_pressed)
	attack_container.add_child(button)
	
	var button1: Button = Button.new()
	button1.scale = Vector2(2, 2) 
	button1.text = "Attack!"
	button1.add_theme_font_size_override("font_size", 24)
	button1.pressed.connect(attack_pressed)
	attack_container.add_child(button1)
	
	var button2: Button = Button.new()
	button2.scale = Vector2(2, 2) 
	button2.text = "Attack!"
	button2.add_theme_font_size_override("font_size", 24)
	button2.pressed.connect(attack_pressed)
	attack_container.add_child(button2)
	
	add_sibling.call_deferred(attack_container)
	add_sibling.call_deferred(tooltip_label)

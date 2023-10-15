extends CharacterBody2D

@export var override_collision_shape: Shape2D
@export var override_animated_sprite: SpriteFrames
@export var override_interaction: Callable

@onready var collision_shape_node = $CollisionShape2D
@onready var animated_sprite_node = $AnimatedSprite2D

var test_dialog = DialogData.new(
	preload("res://dialog_scene/ink/test.ink.json"), false, 
	["test_dialog_visited"])

var test_battle_scene = preload("res://battle_scene/battle_field.tscn")

func _ready():
	pass
	#collision_shape_node.shape = override_collision_shape
	#animated_sprite_node.sprite_frames = override_animated_sprite

func interact():
	EventBus.dialog_start.emit(test_dialog) 
	await EventBus.dialog_finished
	EventBus.battle_request.emit(test_battle_scene)

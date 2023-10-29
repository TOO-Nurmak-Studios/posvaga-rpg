class_name MovableCharacter
extends CharacterBody2D

@export var default_speed = 50
@export var sprint_speed_modifier = 1.5
@export var starting_direction = Vector2.ZERO

@onready var animation_node = $AnimatedSprite2D

var direction = Vector2.ZERO
var stop_position: Vector2
var speed = default_speed
var speed_modifier = 1
var direction_name = "down"
var animation_name
var is_sprinting = false

var dialog_data: DialogData

var playing_cutscene: bool = false

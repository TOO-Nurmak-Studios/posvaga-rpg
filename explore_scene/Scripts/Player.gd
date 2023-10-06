extends CharacterBody2D

@export var default_speed = 50
@export var sprint_speed_modifier = 1.75

@onready var animation_node = $AnimatedSprite2D

var speed = default_speed
var speed_modifier = 1
var direction_name = "down"
var animation_name


func _ready():
	EventBus.player_move_pressed.connect(process_movement)
	EventBus.player_sprint_pressed.connect(process_sprint_pressed)
	EventBus.player_sprint_released.connect(process_sprint_released)


func process_sprint_pressed():
	speed = default_speed * sprint_speed_modifier
	animation_node.speed_scale *= sprint_speed_modifier


func process_sprint_released():
	speed = default_speed
	animation_node.speed_scale = 1


func process_movement(delta, new_velocity):
	velocity = new_velocity.normalized() * speed * delta;
	move_and_collide(velocity)
	play_animation(velocity)


func play_animation(new_direction : Vector2):
	var new_animation_name
	
	if new_direction != Vector2.ZERO:
		
		direction_name = get_direction_name(new_direction)
		
		if direction_name == "left":
			animation_node.flip_h = true
			direction_name = "side"
		elif direction_name == "right":
			animation_node.flip_h = false
			direction_name = "side"
			
		new_animation_name = "walk_" + direction_name
	else:
		new_animation_name = "idle_" + direction_name
	
	if (animation_name != new_animation_name):
		animation_name = new_animation_name
		animation_node.play(animation_name)


func get_direction_name(direction : Vector2):
	const default = "down"
	
	if direction.y > 0:
		return "down"
	elif direction.y < 0:
		return "up"
	elif direction.x > 0:
		return "right"
	elif direction.x < 0:
		return "left"
		
	return default

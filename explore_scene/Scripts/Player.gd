extends CharacterBody2D

@export var default_speed = 50
@export var sprint_speed_modifier = 1.75

@onready var animation_node = $AnimatedSprite2D

var speed = default_speed
var direction_name = "down"

func _physics_process(delta):
	
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("ui_sprint"):
		speed = default_speed * sprint_speed_modifier
		animation_node.speed_scale *= sprint_speed_modifier
	elif Input.is_action_just_released("ui_sprint"):
		speed = default_speed
		animation_node.speed_scale = 1
	
	velocity = velocity.normalized() * speed * delta;
	
	move_and_collide(velocity)
	play_animation(velocity)


func play_animation(new_direction : Vector2):
	var animation_name
	
	if new_direction != Vector2.ZERO:
		
		direction_name = get_direction_name(new_direction)
		
		if direction_name == "left":
			animation_node.flip_h = true
			direction_name = "side"
		elif direction_name == "right":
			animation_node.flip_h = false
			direction_name = "side"
			
		animation_name = "walk_" + direction_name
	else:
		animation_name = "idle_" + direction_name
	
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

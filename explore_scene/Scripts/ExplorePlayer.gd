class_name ExplorePlayer
extends CharacterBody2D

@export var default_speed = 50
@export var sprint_speed_modifier = 1.5
@export var raycast_length = 15

@onready var animation_node = $AnimatedSprite2D
@onready var ray_cast = $RayCast2D

var speed = default_speed
var speed_modifier = 1
var direction_name = "down"
var animation_name

var is_sprinting = false

func _ready():
	EventBus.player_move_pressed.connect(_process_movement)
	EventBus.player_sprint_pressed.connect(_process_sprint_pressed)
	EventBus.player_sprint_released.connect(_process_sprint_released)
	EventBus.player_interact_pressed.connect(_process_interaction)
	
	_process_movement(0, Vector2.ZERO)


func _process_sprint_pressed():
	if !is_sprinting:
		is_sprinting = true
		speed = default_speed * sprint_speed_modifier
		animation_node.speed_scale *= sprint_speed_modifier


func _process_sprint_released():
	is_sprinting = false
	speed = default_speed
	animation_node.speed_scale = 1


func _process_movement(delta, new_velocity):
	velocity = new_velocity.normalized() * speed * delta;
	move_and_collide(velocity)
	play_animation(velocity)
	if new_velocity != Vector2.ZERO:
		ray_cast.target_position = new_velocity.normalized() * raycast_length


func _process_interaction():
	var target = ray_cast.get_collider()
	if target != null:
		if target.is_in_group("Interactible"):
			target.interact()


func play_animation(new_direction : Vector2, idle: bool = false):
	var new_animation_name
	
	# меняем направление если вектор ненулевой
	if new_direction != Vector2.ZERO:
		direction_name = _get_direction_name(new_direction)
		if direction_name == "left":
			animation_node.flip_h = true
			direction_name = "side"
		elif direction_name == "right":
			animation_node.flip_h = false
			direction_name = "side"
	
	if new_direction != Vector2.ZERO && !idle:
		new_animation_name = "walk_" + direction_name
	else:
		new_animation_name = "idle_" + direction_name
	
	if (animation_name != new_animation_name):
		animation_name = new_animation_name
		animation_node.play(animation_name)


func _get_direction_name(direction : Vector2):
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


# для удобства вызовов из CutsceneManager
func turn_left():
	face_direction(NormalizedDirection.LEFT)

func turn_right():
	face_direction(NormalizedDirection.RIGHT)

func turn_up():
	face_direction(NormalizedDirection.UP)

func turn_down():
	face_direction(NormalizedDirection.DOWN)

func face_direction(direction: Vector2):
	play_animation(direction, true)

class_name ExplorePlayer
extends CharacterBody2D

var directions = [NormalizedDirection.LEFT, NormalizedDirection.RIGHT, NormalizedDirection.UP, NormalizedDirection.DOWN]

@export var char_name: String = ""
@export var default_speed = 55
@export var sprint_speed_modifier = 1.5
@export var raycast_length = 15

@onready var animation_node = $AnimatedSprite2D
@onready var interact_area = $Area2D
@onready var interact_icon = $InteractIcon
@onready var footsteps_player = $footsteps_player

var speed = default_speed
var speed_modifier = 1
var direction_name = "down"
var animation_name

var is_sprinting = false
var is_interacting = false

func _ready():
	EventBus.player_move_pressed.connect(_process_movement)
	EventBus.player_sprint_pressed.connect(_process_sprint_pressed)
	EventBus.player_sprint_released.connect(_process_sprint_released)
	EventBus.player_interact_pressed.connect(_process_interaction)
	EventBus.player_interaction_ended.connect(_process_interaction_ended)
	EventBus.cutscene_move_start.connect(try_move_for_cutscene)
	EventBus.cutscene_turn_start.connect(try_turn_for_cutscene)
	
	footsteps_player.set_sprint_speed_modifier(sprint_speed_modifier)
	
	_process_movement(0, Vector2.ZERO)


func _process(_delta):
	var target = _getInteractibleTarget()
	if target != null && !is_interacting:
		interact_icon.show()
	else:
		interact_icon.hide()


func _process_sprint_pressed():
	if !is_sprinting:
		is_sprinting = true
		speed = default_speed * sprint_speed_modifier
		animation_node.speed_scale *= sprint_speed_modifier
		footsteps_player.set_sprint()

func _process_sprint_released():
	is_sprinting = false
	speed = default_speed
	animation_node.speed_scale = 1
	footsteps_player.set_no_sprint()

func _process_movement(delta, new_velocity):
	velocity = new_velocity.normalized() * speed * delta;
	move_and_collide(velocity)
	play_animation(velocity)
	footsteps_player.process_for(velocity)


func _getInteractibleTarget():
	
	# достаем только интерактивные предметы
	var filter_func = func(x): return x.is_in_group("Interactible")
	# сортируем по возврастанию удаленности от игрока, чтобы выбрать ближайший
	var sort_func = func(x, y): return x.position.distance_to(self.position) < y.position.distance_to(self.position)
	
	var interactibles = interact_area.get_overlapping_bodies().filter(filter_func)
	interactibles.sort_custom(sort_func)
	
	if interactibles.size() == 0:
		return null
	
	return interactibles[0]


func _process_interaction():
	var target = _getInteractibleTarget()
	if target != null && !is_interacting:
		is_interacting = true
		interact_icon.hide()
		_turn_to_face_target(target)
		target.interact()

func _process_interaction_ended():
	is_interacting = false

func _turn_to_face_target(target: Node2D):
	var dir = self.position.direction_to(target.position)
	var sort_func = func(x, y): return x.distance_to(dir) < y.distance_to(dir)
	directions.sort_custom(sort_func)
	
	var ld = NormalizedDirection.LEFT.distance_to(dir)
	var rd = NormalizedDirection.RIGHT.distance_to(dir)
	var ud = NormalizedDirection.UP.distance_to(dir)
	var dd = NormalizedDirection.DOWN.distance_to(dir)
	
	face_direction(directions[0])
	

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


func try_move_for_cutscene(object: String, direction: String, distance: int):
	pass # todo

func try_turn_for_cutscene(object: String, direction: String):
	# matchn() instead of == for case-insensitive comparison
	if !char_name.matchn(object):
		return
	match direction:
		"left":
			turn_left()
		"right":
			turn_right()
		"up":
			turn_up()
		"down":
			turn_down()
	EventBus.cutscene_turn_finished.emit()

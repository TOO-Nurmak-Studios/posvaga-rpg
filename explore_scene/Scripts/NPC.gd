extends CharacterBody2D

signal movement_stoped

const TILE_SIZE = 16

@export var char_name: String = ""

@export var default_speed = 50
@export var sprint_speed_modifier = 1.5
@export var starting_direction = Vector2.ZERO

@export var dialog_resource: Resource
@export var dialog_vars: Array[String]
@export var dialog_knot: String

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

func _ready():
	if char_name == "":
		char_name = name
	face_direction(starting_direction)
	if dialog_resource != null:
		dialog_data = DialogData.new(dialog_resource, dialog_vars, dialog_knot)
	EventBus.cutscene_move_start.connect(try_move_for_cutscene)
	EventBus.cutscene_turn_start.connect(try_turn_for_cutscene)

func interact():
	if dialog_resource != null:
		EventBus.dialog_start.emit(dialog_data)
		
func try_move_for_cutscene(object: String, direction: String, distance: int):
	if object != char_name:
		return
	playing_cutscene = true
	match direction:
		"left":
			move_left(distance)
		"right":
			move_right(distance)
		"up":
			move_up(distance)
		"down":
			move_down(distance)

func try_turn_for_cutscene(object: String, direction: String):
	if object != char_name:
		return
	playing_cutscene = true
	match direction:
		"left":
			turn_left()
		"right":
			turn_right()
		"up":
			turn_up()
		"down":
			turn_down()

func move_left(tiles: int, sprint: bool = false):
	stop_position = Vector2(position.x - tiles * TILE_SIZE, position.y)
	direction = NormalizedDirection.LEFT
	_sprint(sprint)

func move_right(tiles: int, sprint: bool = false):
	stop_position = Vector2(position.x + tiles * TILE_SIZE, position.y)
	direction = NormalizedDirection.RIGHT
	_sprint(sprint)

func move_up(tiles: int, sprint: bool = false):
	stop_position = Vector2(position.x, position.y - tiles * TILE_SIZE)
	direction = NormalizedDirection.UP
	_sprint(sprint)

func move_down(tiles: int, sprint: bool = false):
	stop_position = Vector2(position.x, position.y + tiles * TILE_SIZE)
	direction = NormalizedDirection.DOWN
	_sprint(sprint)

func _sprint(on: bool):
	# не обновляем если скорость и так та, что нужно
	if on != is_sprinting:
		if on:
			speed = default_speed * sprint_speed_modifier
			animation_node.speed_scale *= sprint_speed_modifier
		else:
			speed = default_speed
			animation_node.speed_scale = 1

func _physics_process(delta):
	velocity = speed * direction * delta
	play_animation(velocity)
	var collision = move_and_collide(velocity)
	if _reached_position():
		direction = Vector2.ZERO
		movement_stoped.emit()
		if playing_cutscene:
			EventBus.cutscene_move_finished.emit()
			playing_cutscene = false

func _reached_position():
	if direction.y > 0:
		return position.y > stop_position.y
	elif direction.y < 0:
		return position.y < stop_position.y
	elif direction.x > 0:
		return position.x > stop_position.x
	elif direction.x < 0:
		return position.x < stop_position.x
	return position.x < stop_position.x

func _process_movement(delta, new_velocity):
	velocity = new_velocity.normalized() * speed * delta;
	move_and_collide(velocity)
	play_animation(velocity)


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

func _get_direction_name(_direction : Vector2):
	const default = "down"
	
	if _direction.y > 0:
		return "down"
	elif _direction.y < 0:
		return "up"
	elif _direction.x > 0:
		return "right"
	elif _direction.x < 0:
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

func face_direction(_direction: Vector2):
	play_animation(_direction, true)
	if playing_cutscene:
		EventBus.cutscene_turn_finished.emit()
		playing_cutscene = false

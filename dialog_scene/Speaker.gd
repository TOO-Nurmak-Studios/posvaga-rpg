class_name Speaker

extends Node2D

signal moving_finished()

const indent_size = 20

@onready var sprite = $Sprite2D

var bottom: float
var viewport_size: Vector2
var move_speed: float

var left_appear_pos_x: float
var left_disappear_pos_x: float
var right_appear_pos_x: float
var right_disappear_pos_x: float
var target_pos_x: float
var current_speed: float = 0
var current_location: ReplicaData.SpeakerLocation
var current_name: String


func init(_bottom: float, _viewport_size: Vector2, _move_speed: float):
	bottom = _bottom
	viewport_size = _viewport_size
	move_speed = _move_speed


func update(name: String, texture: Texture2D, location: ReplicaData.SpeakerLocation):
	var should_move = name != current_name
	current_name = name
	
	if should_move:
		disappear()
		await moving_finished
	
	current_location = location
	sprite.texture = texture

	var texture_size = texture.get_size()
	var texture_size_x = texture_size.x
	var texture_size_y = texture_size.y

	position.y = bottom - texture_size_y / 2

	left_appear_pos_x = indent_size + texture_size_x / 2
	left_disappear_pos_x = -1 * texture_size_x / 2
	right_appear_pos_x = viewport_size.x - texture_size_x / 2 - indent_size
	right_disappear_pos_x = viewport_size.x + texture_size_x / 2

	if should_move:
		appear()


func appear():
	match(current_location):
		ReplicaData.SpeakerLocation.LEFT:
			position.x = left_disappear_pos_x
			target_pos_x = left_appear_pos_x
			current_speed = move_speed
		ReplicaData.SpeakerLocation.RIGHT:
			position.x = right_disappear_pos_x
			target_pos_x = right_appear_pos_x
			current_speed = -1 * move_speed


func disappear():
	match(current_location):
		ReplicaData.SpeakerLocation.LEFT:
			target_pos_x = left_disappear_pos_x
			current_speed = -1 * move_speed
		ReplicaData.SpeakerLocation.RIGHT:
			target_pos_x = right_disappear_pos_x
			current_speed = move_speed


func _process(delta):
	if current_speed == 0:
		return
	
	var is_more_right = position.x >= target_pos_x
	position.x += current_speed * delta
	if (position.x > target_pos_x) != is_more_right:
		position.x = target_pos_x
		current_speed = 0
		moving_finished.emit()

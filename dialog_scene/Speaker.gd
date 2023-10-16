class_name Speaker

extends Node2D

signal moving_finished()

const indent_size = 20

@onready var sprite = $Sprite2D

var bottom: float
var viewport_size: Vector2
var move_speed: float

var appear_pos_x: float = 0
var disappear_pos_x: float = 0
var target_pos_x: float = 0
var current_speed: float = 0
var location: ReplicaData.SpeakerLocation


func init(
			_bottom: float,
			_viewport_size: Vector2,
			_move_speed: float):

	bottom = _bottom
	viewport_size = _viewport_size
	move_speed = _move_speed


func update(_location: ReplicaData.SpeakerLocation, _texture: Texture2D):
	sprite.texture = _texture

	var texture_size = _texture.get_size()
	var texture_size_x = texture_size.x
	var texture_size_y = texture_size.y

	position.y = bottom - texture_size_y / 2

	if _location == ReplicaData.SpeakerLocation.DEFAULT:
		return

	location = _location

	match(location):
		ReplicaData.SpeakerLocation.LEFT:
			appear_pos_x = indent_size + texture_size_x / 2
			disappear_pos_x = -1 * texture_size_x / 2
		ReplicaData.SpeakerLocation.RIGHT:
			appear_pos_x = viewport_size.x - texture_size_x / 2 - indent_size
			disappear_pos_x = viewport_size.x + texture_size_x / 2


func set_appeared():
	position.x = appear_pos_x


func set_disappeared():
	position.x = disappear_pos_x


func appear():
	position.x = disappear_pos_x
	target_pos_x = appear_pos_x
	
	match(location):
		ReplicaData.SpeakerLocation.LEFT:
			current_speed = move_speed
		ReplicaData.SpeakerLocation.RIGHT:
			current_speed = -1 * move_speed
			
	await moving_finished


func disappear():
	target_pos_x = disappear_pos_x
	
	match(location):
		ReplicaData.SpeakerLocation.LEFT:
			current_speed = -1 * move_speed
		ReplicaData.SpeakerLocation.RIGHT:
			current_speed = move_speed
			
	await moving_finished


func _process(delta):
	if current_speed == 0:
		return
	
	var is_more_right = position.x >= target_pos_x
	position.x += current_speed * delta
	if (position.x > target_pos_x) != is_more_right:
		position.x = target_pos_x
		current_speed = 0
		moving_finished.emit()

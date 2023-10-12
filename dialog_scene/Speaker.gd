class_name Speaker

extends Node2D

@onready var sprite = $Sprite2D

var left_appear_pos_x: float
var right_appear_pos_x: float

var bottom: float
var viewport_size: Vector2

func init(_bottom: float, _viewport_size: Vector2):
	bottom = _bottom
	viewport_size = _viewport_size


func set_texture(texture: Texture2D, location: ReplicaData.Location):
	sprite.texture = texture

	var texture_size = texture.get_size()
	var texture_size_x = texture_size.x
	var texture_size_y = texture_size.y

	position.y = bottom - texture_size_y / 2

	left_appear_pos_x = texture_size_x / 2 + 20
	right_appear_pos_x = viewport_size.x - texture_size_x / 2 - 20

	match(location):
		ReplicaData.Location.LEFT:
			position.x = left_appear_pos_x
		ReplicaData.Location.RIGHT:
			position.x = right_appear_pos_x


func appear(location: ReplicaData.Location):
	match(location):
		ReplicaData.Location.LEFT:
			position.x = left_appear_pos_x
		ReplicaData.Location.RIGHT:
			position.x = right_appear_pos_x
	show()


func disappear():
	hide()

class_name Speaker

extends Node2D

var appear_pos_x: float
var disappear_pos_x: float

func _ready():
	pass

func _process(delta):
	pass

func init(texture: Texture2D, location: SpeakerData.Location, bottom: float, viewport_size: Vector2):
	$Sprite2D.texture = texture
	
	var texture_size = texture.get_size()
	var texture_size_x = texture_size.x
	var texture_size_y = texture_size.y
	
	if texture_size_x > viewport_size.x / 2:
		scale.x = 0.5
		texture_size_x /= 2
	
	if texture_size_y > viewport_size.y / 2:
		scale.y = 0.5
		texture_size_y /= 2
	
	position.y = bottom - texture_size_y / 2
	
	match(location):
		SpeakerData.Location.LEFT:
			appear_pos_x = texture_size_x / 2
			disappear_pos_x = -1 * (texture_size_x / 2)
		SpeakerData.Location.RIGHT:
			appear_pos_x = viewport_size.x - texture_size_x / 2
			disappear_pos_x = viewport_size.x + texture_size_x / 2
	
	disappear()

func appear():
	position.x = appear_pos_x

func disappear():
	position.x = disappear_pos_x

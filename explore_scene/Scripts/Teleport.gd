extends Area2D
class_name Teleport

@export var scene_name: String
@export var player_position: Vector2 = Vector2.ZERO
@export var player_direction: Vector2 = Vector2.ZERO

var _loaded_scene

func _ready():
	body_entered.connect(_on_body_entered)
	_loaded_scene = load(scene_name)

func _on_body_entered(body):
	if body != null && body.is_in_group("Player"):
		EventBus.teleport_request.emit(_loaded_scene, player_position, player_direction)

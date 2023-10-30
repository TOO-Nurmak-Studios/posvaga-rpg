extends Area2D
class_name Teleport

@export var scene_name: String
@export var player_position: Vector2 = Vector2.ZERO
@export var player_direction: Vector2 = Vector2.ZERO
@export var visibility_flag: String
@export var invert_visibility_flag: bool

var _loaded_scene

func _ready():
	body_entered.connect(_on_body_entered)
	_loaded_scene = load(scene_name)
	if visibility_flag != null && visibility_flag != "":
		_update_visible()
		EventBus.game_state_changed.connect(_update_visible)

func _on_body_entered(body):
	if body != null && body.is_in_group("Player"):
		EventBus.teleport_request.emit(_loaded_scene, player_position, player_direction)

func _update_visible():
	var flag_value = GameState.vars.get(visibility_flag, false)
	print("Updating visibility for " + self.name + ", flag: " + str(visibility_flag) + " = " + str(flag_value) + ", inverted = " + str(invert_visibility_flag))
	if flag_value != invert_visibility_flag:
		monitoring = true
	else:
		monitoring = false

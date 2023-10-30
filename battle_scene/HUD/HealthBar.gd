class_name HealthBar
extends TextureProgressBar

var _margin: Vector2
var parent: Node2D

@onready var defense_icon: Sprite2D = $DefenseIcon

func update_value(_old_value: float, new_value: float):
	value = new_value

func enable_defense():
	defense_icon.visible = true

func disable_defense():
	defense_icon.visible = false

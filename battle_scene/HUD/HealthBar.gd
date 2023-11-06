class_name HealthBar
extends TextureProgressBar

const update_duration = 0.5

var _margin: Vector2
var parent: Node2D

@onready var defense_icon: Sprite2D = $DefenseIcon

func update_value(_old_value: float, new_value: float):
	var t = create_tween()
	t.tween_property(self, "value", new_value, update_duration)

func enable_defense():
	defense_icon.visible = true

func disable_defense():
	defense_icon.visible = false

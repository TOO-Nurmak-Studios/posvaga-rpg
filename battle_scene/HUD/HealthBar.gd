class_name HealthBar
extends TextureProgressBar

var _margin: Vector2
var parent: Node2D

func update_value(_old_value: float, new_value: float):
	value = new_value

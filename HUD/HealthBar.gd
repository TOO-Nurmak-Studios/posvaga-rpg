class_name HealthBar
extends TextureProgressBar

var _margin: Vector2
var parent: Node2D

# Called when the node enters the scene tree for the first time.
#func _ready():
	#parent = get_parent()
	#if parent != null:
	#	max_value = parent.get("health");
	#	update_value(max_value);
	#else:
	#	printerr("Tried to add HP bar to entity with no health!")
	#	queue_free()
	#pass # Replace with function body.


func update_value(old_value: float, new_value: float):
	value = new_value

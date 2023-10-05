class_name Projectile
extends Node2D

var _visible_on_screen_notifier: VisibleOnScreenNotifier2D
var damage: int
var target: Vector2

func _ready():
	_visible_on_screen_notifier = VisibleOnScreenNotifier2D.new()
	_visible_on_screen_notifier.rect = Rect2(Vector2.ZERO, Vector2.ONE)
	add_child(_visible_on_screen_notifier)
	_visible_on_screen_notifier.screen_exited.connect(queue_free)
	pass



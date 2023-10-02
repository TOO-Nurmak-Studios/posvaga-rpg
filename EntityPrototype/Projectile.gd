class_name Projectile
extends MovableArea2D

var _visible_on_screen_notifier: VisibleOnScreenNotifier2D
var damage: int

# Called when the node enters the scene tree for the first time.
func _ready():
	_visible_on_screen_notifier = VisibleOnScreenNotifier2D.new()
	_visible_on_screen_notifier.rect = Rect2(Vector2.ZERO, Vector2.ONE)
	add_child(_visible_on_screen_notifier)
	_visible_on_screen_notifier.screen_exited.connect(queue_free)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


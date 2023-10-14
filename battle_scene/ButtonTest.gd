extends Button

@onready var sprite: Sprite2D = $Sprite2D
var selected = preload("res://sprites/test_button_selected.png")
var default = preload("res://sprites/test_button.png")

func _ready():
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)

func _on_mouse_enter():
	sprite.texture = selected

func _on_mouse_exit():
	sprite.texture = default

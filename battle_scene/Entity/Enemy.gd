class_name Enemy
extends AbstractCharacter

@onready var sprite: Sprite2D = $Sprite

var default_sprite: Resource = preload("res://sprites/chel.png")
var selected_sprite: Resource = preload("res://sprites/chel_selected.png")

func select():
	sprite.set_texture(selected_sprite)

func unselect():
	sprite.set_texture(default_sprite)

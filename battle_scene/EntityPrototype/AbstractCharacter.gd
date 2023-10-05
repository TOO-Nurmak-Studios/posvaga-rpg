class_name AbstractCharacter
extends Node2D

@onready var crosshair: Marker2D = $Crosshair
@onready var health: HealthNode = $HealthNode as HealthNode

signal death(dead_char: AbstractCharacter)

func _ready():	
	health.zero_health.connect(die)
	pass

func take_damage(damage: int):
	health.remove_health(damage)
	
func die():
	death.emit(self)
	queue_free()

func select():
	pass

func unselect():
	pass

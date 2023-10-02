class_name CharacterWithHealth
extends MovableArea2D

@export var health: int = 100
signal health_changed(old_value, new_value) 

func _ready():
	pass

func remove_health(i: int):
	var old_hp = health
	health -= i
	health_changed.emit(old_hp, health)
	if health <= 0:
		queue_free()
	pass	

func _process(delta: float):
	pass

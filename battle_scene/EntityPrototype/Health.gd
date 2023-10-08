extends Node2D
class_name HealthNode

@export var health: int = 100
signal health_changed(old_value, new_value) 
signal zero_health()

func remove_health(i: int):
	var old_hp = health
	health -= i
	health_changed.emit(old_hp, health)
	if old_hp > 0 && health <= 0:
		zero_health.emit()
	pass	
	

extends Node2D
class_name HealthNode

const NO_DAMAGE_REDUCTION = -1

@export var health: int = 100
signal health_changed(old_value, new_value) 
signal zero_health()

var health_bar: HealthBar
var damage_reduction: float = NO_DAMAGE_REDUCTION

func remove_health(i: int):
	var old_hp = health
	if damage_reduction != NO_DAMAGE_REDUCTION:
		i *= damage_reduction
		disable_damage_reduction()
	health -= i
	health_changed.emit(old_hp, health)
	if old_hp > 0 && health <= 0:
		zero_health.emit()
	
func add_damage_reduction(dmg_red: float):
	health_bar.enable_defense()
	damage_reduction = dmg_red

func disable_damage_reduction():
	damage_reduction = NO_DAMAGE_REDUCTION
	health_bar.disable_defense()

class_name Enemy
extends AbstractCharacter

@onready var rand = RandomNumberGenerator.new()

func _init():
	attacks = [TripleShotAttack.new()]
	attack_animations = ["shoot_shotgun"]

func get_type() -> CharacterType:
	return CharacterType.ENEMY 
	
func do_move(enemies: Array[Node], allies: Array[Node]):
	var attack_index = rand.randi_range(0, attacks.size() - 1)
	var enemy_index = rand.randi_range(0, enemies.size() - 1)
	attack(attack_index, enemies[enemy_index])
	pass

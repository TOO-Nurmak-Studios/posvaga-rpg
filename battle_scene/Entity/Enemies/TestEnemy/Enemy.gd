class_name Enemy
extends AbstractCharacter

@onready var rand = BetterRandNumGen.new()

var move_timer: MoveTimer
var prepared_attack_index: int
var has_moved: bool = false

var _weights = []
var _total_weight
var _single_attack: bool = false
var _same_weights: bool = false

func _init():
	attacks = [TripleShotAttack.new()]
	
func _ready():
	super._ready()
	sprite.play("idle")
	if _weights.is_empty():
		for attack in attacks:
			_weights.push_back(1)
	_total_weight = _weights.reduce(func(acc, next): return acc + next, 0)
	_single_attack = attacks.size() == 1
	_same_weights = _weights.all(func(x): return x == _weights[0])

func get_type() -> CharacterType:
	return CharacterType.ENEMY 
	
func do_move(enemies: Array[Node], allies: Array[Node]):
	var enemy_index = rand.randi_range(0, enemies.size() - 1)
	attack(attacks[prepared_attack_index], enemies[enemy_index])
	
func set_enemy_thinking():
	move_timer.set_thinking()
	
func prepare_random_attack():
	var attack_index
	if _single_attack:
		attack_index = 0
	elif _same_weights:
		attack_index = rand.randi_range(0, attacks.size() - 1)
	else:
		attack_index = _generate_weight_based_index()

	_start_timer_for_attack(attacks[attack_index])
	prepared_attack_index = attack_index
	
func _generate_weight_based_index():
	return RandomUtils.generate_weight_based_index(_weights, _total_weight)

func _start_timer_for_attack(attack: Attack):
	move_timer.set_moves_amount(attack.cooldown)

func decrement_time():
	move_timer.decrement_moves()
	
func moves_left() -> int:
	return move_timer.current_moves

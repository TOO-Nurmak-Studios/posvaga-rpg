class_name Enemy
extends AbstractCharacter

@onready var rand = RandomNumberGenerator.new()

var move_timer: MoveTimer
var prepared_attack_index: int
var has_moved: bool = false

func _init():
	attacks = [TripleShotAttack.new()]
	
func _ready():
	super._ready()
	sprite.play("idle")

func get_type() -> CharacterType:
	return CharacterType.ENEMY 
	
func do_move(enemies: Array[Node], allies: Array[Node]):
	var enemy_index = rand.randi_range(0, enemies.size() - 1)
	attack(prepared_attack_index, enemies[enemy_index])
	
func set_enemy_thinking():
	move_timer.set_thinking()
	
func prepare_random_attack():
	var attack_index = rand.randi_range(0, attacks.size() - 1)
	_start_timer_for_attack(attacks[attack_index])
	prepared_attack_index = attack_index
	
func _start_timer_for_attack(attack: Attack):
	move_timer.set_moves_amount(attack.cooldown)

func decrement_time():
	move_timer.decrement_moves()
	
func moves_left() -> int:
	return move_timer.current_moves

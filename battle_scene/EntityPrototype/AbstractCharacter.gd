class_name AbstractCharacter
extends Node2D

@onready var crosshair: Marker2D = $Crosshair
@onready var health: HealthNode = $HealthNode as HealthNode

@export var char_name: String = "Unnamed Character"
@export var initiative: int

@export var attacks: Array[Attack]
@export var attack_animations: Array[String]

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var gunpoint: Marker2D = $Crosshair

var in_flight_attack: Callable
var is_attack_in_flight = false

enum CharacterType {UNKNOWN, PLAYER, ENEMY}

signal death(dead_char: AbstractCharacter)

func _init():
	attacks = [SingleShotAttack.new(), TripleShotAttack.new()]
	attack_animations = ["shoot", "shoot_shotgun"]

func _ready():
	initiative = 10 + RandomNumberGenerator.new().randi_range(-5, 5)
	health.zero_health.connect(die)
	for attack in attacks:
		add_sibling.call_deferred(attack)

func attack(index: int, enemy_to_attack):
	sprite.play(attack_animations[index])
	is_attack_in_flight = true
	in_flight_attack = func():
		sprite.animation = "idle"
		sprite.animation_finished.disconnect(in_flight_attack)
		attacks[index].attack(self, enemy_to_attack, gunpoint)
		is_attack_in_flight = false
	sprite.animation_finished.connect(in_flight_attack)

func select():
	sprite.animation = "idle_selected"

func unselect():
	if !is_attack_in_flight:
		sprite.animation = "idle"

func take_damage(damage: int):
	health.remove_health(damage)
	
func die():
	death.emit(self)
	queue_free()

func get_type() -> CharacterType:
	return CharacterType.UNKNOWN 

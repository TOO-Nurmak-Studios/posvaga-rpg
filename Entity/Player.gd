class_name Player
extends AbstractCharacter

@export var attacks: Array[Attack]
@export var attack_animations: Array[String]

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var gunpoint: Marker2D = $Crosshair

var in_flight_attack: Callable

func _init():
	attacks = [SingleShotAttack.new(), TripleShotAttack.new()]
	attack_animations = ["shoot", "shoot_shotgun"]

func _ready():
	for attack in attacks:
		add_sibling.call_deferred(attack)

func attack(index: int, enemy_to_attack):
	sprite.play(attack_animations[index])
	in_flight_attack = func():
		sprite.animation = "idle"
		sprite.animation_finished.disconnect(in_flight_attack)
		attacks[index].attack(enemy_to_attack, gunpoint)
	sprite.animation_finished.connect(in_flight_attack)

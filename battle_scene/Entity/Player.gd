class_name Player
extends AbstractCharacter

func _init():
	attacks = [SingleShotAttack.new(), TripleShotAttack.new()]
	attack_animations = ["shoot", "shoot_shotgun"]

func _ready():
	super._ready()

func get_type() -> CharacterType:
	return CharacterType.PLAYER 

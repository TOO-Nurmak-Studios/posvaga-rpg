class_name Player
extends AbstractCharacter

func _init():
	attacks = [SingleShotAttack.new(), TripleShotAttack.new(), PointBlankShot.new()]

func _ready():
	super._ready()

func get_type() -> CharacterType:
	return CharacterType.PLAYER 

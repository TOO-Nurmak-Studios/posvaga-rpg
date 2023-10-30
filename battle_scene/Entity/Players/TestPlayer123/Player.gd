class_name Player123
extends AbstractCharacter

func _init():
	attacks = [SingleShotAttack.new()]

func _ready():
	super._ready()
	sprite.play("idle")

func get_type() -> CharacterType:
	return CharacterType.PLAYER 

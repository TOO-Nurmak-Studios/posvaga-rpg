class_name Laborantka
extends AbstractCharacter

func _init():
	attacks = [LabKick.new(), LabDefense.new(), ThrowBookAttack.new()]

func _ready():
	super._ready()
	sprite.play("idle")
	unselect()

func get_type() -> CharacterType:
	return CharacterType.PLAYER 

func select():
	var sh = self.sprite.material as ShaderMaterial
	sh.set_shader_parameter("width", 1)

func unselect():
	var sh = self.sprite.material as ShaderMaterial
	sh.set_shader_parameter("width", 0)

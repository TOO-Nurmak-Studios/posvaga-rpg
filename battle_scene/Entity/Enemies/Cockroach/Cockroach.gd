class_name Cockroach
extends Enemy

func _init():
	attacks = [CockroachBite.new()]

func _ready():
	super._ready()
	char_name = "Cock Roach"

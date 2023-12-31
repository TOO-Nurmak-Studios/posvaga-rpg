extends Node

@export var music_file_name = ""
@export var music_volume = "."
@export var env_file_name = ""
@export var env_volume = "."

var main_scene = preload("res://main_scene/Main.tscn")

func _ready():
	if get_parent().name != "Main":
		var main = main_scene.instantiate()
		main.init(self.scene_file_path)
		var parent = get_parent()
		get_parent().add_child.call_deferred(main)
		self.queue_free.call_deferred()
	
	EventBus.music_play_new.emit(music_file_name, "0.3", "0.3", music_volume)
	EventBus.env_play_new.emit(env_file_name, "0.3", "0.3", env_volume)

extends Node

var main_scene = preload("res://main_scene/Main.tscn")

func _ready():
	if get_parent().name != "Main":
		var main = main_scene.instantiate()
		main.init(self.scene_file_path)
		var parent = get_parent()
		get_parent().add_child.call_deferred(main)
		self.queue_free.call_deferred()

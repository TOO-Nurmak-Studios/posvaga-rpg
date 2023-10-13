class_name DialogData

var ink_file: Resource
var is_cutscene: bool
## Названия переменных из глобального состояния игры,
## которые используются в диалоге, могут читаться и записываться
var var_names: Array[String]

func _init(_ink_file: Resource, _is_cutscene: bool, _var_names: Array[String]):
	ink_file = _ink_file
	is_cutscene = _is_cutscene
	var_names = _var_names

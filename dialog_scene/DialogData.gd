class_name DialogData

## Ресурс с ink-диалогом, скомпилированный в json.
var ink_file: Resource

## Название стартового узла. 
## Если null или пустая строка, то запускает файл с самого начала.
## Позволяет хранить несколько диалогов в одном файле.
var starting_knot: String

## Названия переменных из глобального состояния игры,
## которые используются в диалоге, могут читаться и записываться.
var var_names: Array[String]

func _init(_ink_file: Resource, _var_names: Array[String], _starting_knot: String = ""):
	ink_file = _ink_file
	var_names = _var_names
	starting_knot = _starting_knot

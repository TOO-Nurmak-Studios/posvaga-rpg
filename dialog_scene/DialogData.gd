class_name DialogData

## Ресурс с ink-диалогом, скомпилированный в json.
var ink_file: Resource

## Название стартового узла. 
## Если null или пустая строка, то запускает файл с самого начала.
## Позволяет хранить несколько диалогов в одном файле.
var starting_knot: String

func _init(_ink_file: Resource, _starting_knot: String = ""):
	ink_file = _ink_file
	starting_knot = _starting_knot

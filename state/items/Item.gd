class_name Item

enum Type {
	GOLD, SYROK, LIHO
}

func get_item_by_type(type: Type):
	match type:
		Type.SYROK:
			return Syrok.new()
		Type.LIHO:
			return Liho.new()

const texture_files_prefix = "res://sprites/items/"

var id: String
var type: Type
var item_name: String
var description: String
var texture_full_file_name: String
var cost: int


func _init(
		_id: String,
		_type: Type,
		_item_name: String,
		_description: String,
		_texture_file_name: String,
		_cost: int = 0):
	
	id = _id
	type = _type
	item_name = _item_name
	description = _description
	texture_full_file_name = texture_files_prefix + _texture_file_name
	cost = _cost

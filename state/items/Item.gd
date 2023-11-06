class_name Item


const texture_files_prefix = "res://sprites/items/"


var id: String
var item_name: String
var description: String
var texture_full_file_name: String
var cost: int


func _init(
		_id: String,
		_item_name: String,
		_description: String,
		_texture_file_name: String,
		_cost: int = 0):
	
	id = _id
	item_name = _item_name
	description = _description
	texture_full_file_name = texture_files_prefix + _texture_file_name
	cost = _cost

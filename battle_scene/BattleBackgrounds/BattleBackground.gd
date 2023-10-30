extends Node2D
class_name BattleBackground

var player_markers: Array[Node]
var enemy_markers: Array[Node]

func _ready():
	player_markers = get_tree().get_nodes_in_group("player_marker")
	enemy_markers = get_tree().get_nodes_in_group("enemy_marker")
		

extends Node3D

class_name GameManager

@export
var player : Node3D

@export
var boat : Node3D

var player_map : Map
var boat_map : Map

func _ready():
	player_map = player.find_child("Map")
	boat_map = boat.find_child("Map")

func map_collected() -> void:
	print("Map Collected : " + str(player_map.unlocked_parts))
	
	player_map.unlock_map_section()
	boat_map.unlock_map_section()

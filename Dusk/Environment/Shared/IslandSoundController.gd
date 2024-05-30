extends Node3D

@onready
var player : CharacterBody3D 

@onready
var ambiant_sound_player : AmbientSoundPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_parent_node_3d().get_node("Player")
	ambiant_sound_player = get_parent_node_3d().get_parent_node_3d().get_node("AmbientSound")

func distance_to_player() -> float:
	return (global_position - player.global_position).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ambiant_sound_player.island_distance = distance_to_player()
	

extends Node3D

@onready
var player : Node3D 

@onready
var ambiant_sound_player : AmbientSoundPlayer

@onready
var island0 : Node3D

@onready
var island1 : Node3D

@onready
var island2 : Node3D

@onready
var island3 : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_parent_node_3d().get_node("Player")
	ambiant_sound_player = get_parent_node_3d().get_parent_node_3d().get_node("AmbientSound")
	
	island0 = get_parent_node_3d().get_node("Island0Terrain")
	island1 = get_parent_node_3d().get_node("Island1Terrain")

func distance_to_player() -> float:
	return (global_position - player.global_position).length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player == null):
		player = get_parent_node_3d().get_parent_node_3d().get_node("Boat")
	
	ambiant_sound_player.island_distance = distance_to_player()
	

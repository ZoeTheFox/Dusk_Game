extends Node3D

@onready
var player : CharacterBody3D 

const lightning_resource : String = "res://Environment/Shared/Thunder/LightningAndThunder.tscn";

@export
var spawn_radius : float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_parent_node_3d().get_node("Player")


func spawn_lightning():
	var player_position
	if (player == null):
		player_position = global_position
	else:
		player_position = player.global_transform.origin
	
	var random_point = Vector3()
	
	# Generate a random point within the spawn_radius
	var angle = randf() * 2.0 * PI
	var distance = randf() * spawn_radius
	random_point.x = player_position.x + distance * cos(angle)
	random_point.z = player_position.z + distance * sin(angle)
	
	# Set the Y coordinate to be above the player
	random_point.y = player_position.y + 50.0 # Adjust height as needed
	
	# Instance and position the lightning
	var lightning_instance = preload(lightning_resource)
	lightning_instance.instantiate()
	lightning_instance.global_transform.origin = random_point
	get_tree().current_scene.add_child(lightning_instance)
	
	lightning_instance.lightning()
	
	print("Lightning spawned at: ", random_point)
	



extends Node3D

@onready
var player : CharacterBody3D 

const lightning_resource : String = "res://Environment/Shared/Thunder/LightningAndThunder.tscn";

@export
var spawn_radius : float = 200

@export
var min_spawn_time : float = 2

@export
var max_spawn_time : float = 40

@onready
var timer : Timer = $Timer

var muffled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d().get_parent_node_3d().get_node("Player")
	timer.start(get_random_time())

func get_random_time() -> float:
	return randf_range(min_spawn_time, max_spawn_time)

func spawn_lightning():
	var player_position : Vector3
	
	if (player == null):
		player_position = global_position
	else:
		player_position = player.global_transform.origin
	
	var random_position : Vector3 = get_random_position(player_position)
	
	# Instance and position the lightning
	var lightning_scene := preload(lightning_resource)
	
	var lightning_instance : Lightning = lightning_scene.instantiate()
	
	get_tree().current_scene.add_child(lightning_instance)
	
	lightning_instance.global_position = random_position
	
	lightning_instance.set_muffled(muffled)
	
	lightning_instance.lightning()
	
	lightning_instance.lightning_finished.connect(remove_lightning_instance)

func remove_lightning_instance(instance : Lightning) -> void:
	get_tree().current_scene.remove_child(instance)

func get_random_position(player_position : Vector3) -> Vector3:
	var random_direction_normalized : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	var player_position_2d : Vector2 = Vector2(player_position.x, player_position.z)
	
	var random_direction : Vector2 = random_direction_normalized * spawn_radius
	
	var random_location = player_position_2d + random_direction
	
	return Vector3(random_location.x, 30, random_location.y)



func _on_timer_timeout():
	spawn_lightning()
	timer.start(get_random_time())

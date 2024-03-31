extends Node3D

class_name Interactable

@export
var prompt_locations_container : Node3D

signal interact

var is_being_looked_at : bool

var timer : Timer = Timer.new()

var camera : Camera3D

@onready
var interaction_prompt = $InteractionPrompt

func _ready():
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", _on__timer_timeout)
	add_child(timer)

func _process(delta):
	if (camera != null):
		interaction_prompt.global_position = calculate_midpoint_with_sideways_offset(global_position, camera.global_position, 0.1)
		interaction_prompt.look_at(camera.global_position)

func on_look(camera_looking_at : Camera3D):
	camera = camera_looking_at
	
	is_being_looked_at = true
	
	interaction_prompt.show()
	
	#var prompt_location = get_closest_prompt_marker(camera.global_position).global_position
	
	#interaction_prompt.global_position = prompt_location

	
	#print(calculate_midpoint_with_sideways_offset(global_position, camera.global_position, 0.1))
	
	is_being_looked_at = false
	
	timer.start()
	
func on_interact() -> void:
	interact.emit()

func get_closest_prompt_marker(position : Vector3) -> Marker3D:
	var closest_marker : Marker3D
	var closest_distance : float = 100
	
	for p : Marker3D in prompt_locations_container.get_children():
		var distance = p.global_position.distance_to(position)
		
		if (distance < closest_distance):
			closest_distance = distance
			closest_marker = p
		
	return closest_marker

func calculate_midpoint_with_sideways_offset(pos1: Vector3, pos2: Vector3, offset_distance: float) -> Vector3:
	var midpoint = (pos1 + pos2) / 2.0
	var direction = (pos2 - pos1).normalized()
	# Calculate perpendicular vector
	var perpendicular = Vector3(direction.z, 0, -direction.x).normalized()
	var offset = perpendicular * offset_distance
	var offset_position = midpoint + offset
	return offset_position


func _on__timer_timeout():
	if (!is_being_looked_at):
		interaction_prompt.hide()

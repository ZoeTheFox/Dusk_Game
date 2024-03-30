extends Node3D

@export
var camera : Camera3D

@export
var interaction_distance : float

@onready
var interaction_prompt_instance = preload("res://InteractableSystem/InteractionPrompt.tscn")

#@onready
#var interaction_prompt = interaction_prompt_instance.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var space_state = get_world_3d().direct_space_state
		
	var from = camera.global_position
	var to = camera.global_position + -camera.get_global_transform().basis.z * interaction_distance
	
	var raycast = PhysicsRayQueryParameters3D.create(from, to, 16384)
		
	var result = space_state.intersect_ray(raycast)

	var interactable_object : Interactable

	if (result):
		if (result.collider is Interactable):
			interactable_object = result.collider
	else:
		return
	

	interactable_object.is_being_looked_at = true
			
	if (Input.is_action_just_pressed("interact")):
		if (result.collider is Interactable):
			result.collider.on_interact()
			place_interaction_prompt(interactable_object)
	
	interactable_object.is_being_looked_at = false

func place_interaction_prompt(object: Interactable):
	var interaction_prompt = interaction_prompt_instance.instantiate()

	# Calculate position relative to the object
	var offset = Vector3(0, 0, 3)  # Example offset, adjust as needed
	var prompt_position = object.global_transform.origin + offset

	# Ensure the interaction prompt faces the camera
	var camera_direction = (camera.global_transform.origin - prompt_position).normalized()
	var up_vector = Vector3.UP
	var right_vector = camera_direction.cross(up_vector).normalized()
	var look_rotation = right_vector.cross(camera_direction)

	# Set position and rotation of the interaction prompt
	interaction_prompt.global_transform.origin = prompt_position
	interaction_prompt.global_transform.basis.x = right_vector
	interaction_prompt.global_transform.basis.y = camera_direction
	interaction_prompt.global_transform.basis.z = look_rotation

	object.add_child(interaction_prompt)
	

	

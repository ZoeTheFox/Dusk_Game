
extends Camera3D

# Bobbing parameters
var bobbing_speed = 4.0 # Speed of the bobbing. Adjust based on player speed.
var bobbing_amount = 0.05 # How much the camera moves up and down.

# Tracking variables
var timer = 0.0 # Keep track of the time to calculate the bobbing position.
var target_position_y = 0.0 # Target y position of the camera.
var original_position_y = 0.0 # Original y position of the camera to return to.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func head_bobbing(strength : float):
	timer += get_process_delta_time() * bobbing_speed
	var bobbing_offset = sin(timer) * bobbing_amount
	target_position_y = original_position_y + bobbing_offset

	# Smoothly interpolate the camera's position to create a smooth bobbing effect
	var camera_position = transform.origin
	camera_position.y = lerp(camera_position.y, target_position_y, get_process_delta_time() * bobbing_speed)
	transform.origin = camera_position



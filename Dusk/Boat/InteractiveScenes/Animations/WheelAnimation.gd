extends Node3D

var wheel_rotation : float = 0

func _process(delta):
	var wheel = $SteeringWheel
	
	wheel.rotation.y = deg_to_rad(wheel_rotation * -300.0)
	

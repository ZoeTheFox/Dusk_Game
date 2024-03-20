extends Node3D

var wheel_rotation : float = 0

func _process(delta):
	var wheel = $SteeringWheel
	
	wheel.rotation.y = wheel_rotation * -100.0
	

extends Node3D

var wheel_rotation : float = 0.5

func _process(delta):
	var wheel = $SteeringWheel
	
	wheel.rotation.y = wheel_rotation * 200.0 - 100.0
	

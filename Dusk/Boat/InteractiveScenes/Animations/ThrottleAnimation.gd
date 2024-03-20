extends Node3D


var throttle : float = 0

func _process(delta):
	var throttle_node = $ThrottleBase/ThrottleStick

	throttle_node.rotation.z = deg_to_rad(90 + 30 * throttle)

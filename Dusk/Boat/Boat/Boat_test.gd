extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_key_pressed(KEY_T)):
		$AnimationController.wheel_turn = 1
		$AnimationController.throttle = 1
	else:
		$AnimationController.wheel_turn = 0
		$AnimationController.throttle = -1

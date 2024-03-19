extends Node3D

@export
var wheel_turn : float

@export
var throttle : float

@export
var wheel : Node3D

@export
var throttle_node : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wheel.wheel_rotation = wheel_turn
	throttle_node.throttle = throttle

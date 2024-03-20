extends Node3D

var door_open : bool = false

@onready
var animation : AnimationPlayer = $AnimationPlayer

func use_door():
	if (animation.is_playing()):
		return
	
	if (door_open):
		animation.play("close_door")
		door_open = false
	else:
		animation.play("open_door")
		door_open = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

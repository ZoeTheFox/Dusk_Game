extends Node3D

var door_open : bool = false

@export
var animation_player : AnimationPlayer

func use_door():
	if (animation_player.is_playing()):
		return
	
	if (door_open):
		animation_player.play("CloseDoor")
		door_open = false
	else:
		animation_player.play("OpenDoor")
		door_open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	use_door()



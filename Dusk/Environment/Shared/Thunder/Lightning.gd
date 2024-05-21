extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func lightning():
	$Sprite3D.show()
	$OmniLight3D.show()
	$AudioStreamPlayer3D.play()
	await get_tree().create_timer(0.09).timeout
	$Sprite3D.hide()
	$OmniLight3D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.

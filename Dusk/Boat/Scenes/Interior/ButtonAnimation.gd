extends Node3D

@onready
var animation : AnimationPlayer = $AnimationPlayer

func on_press():
	if !animation.is_playing():
		animation.play("button_press")

extends Node3D

signal button_press

@onready
var animation : AnimationPlayer = $AnimationPlayer

func on_press():
	if !animation.is_playing():
		animation.play("button_press")
		button_press.emit()

func _on_interactable_interact():
	on_press()

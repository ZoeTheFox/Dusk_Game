extends Node3D

class_name Lightning

signal lightning_finished(instance : Lightning)

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
	$Timer.start()
	




func _on_timer_timeout():
	lightning_finished.emit(self)

extends Node3D

class_name Interactable



var is_being_looked_at : bool

var timer : Timer = Timer.new()


func on_interact() -> void:
	assert(false, "This method must be overriden.")


func _ready():
	timer.wait_time = 0.4
	timer.one_shot = true
	
	add_child(timer)
	
	timer.connect("timeout", _on__timer_timeout)

func _on__timer_timeout():
	pass


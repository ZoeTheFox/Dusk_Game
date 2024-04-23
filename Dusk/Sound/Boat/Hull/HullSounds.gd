extends Node3D

func set_muffled(state : bool):
	if (state):
		$AudioStreamPlayer3D.bus = "Muffle"
	else:
		$AudioStreamPlayer3D.bus = "Environment"

extends Node3D

class_name Map

var unlocked_parts : int = 0

func unlock_map_section() -> void:
	get_child(unlocked_parts).show()
	
	print("unlocked map " + str(unlocked_parts))
	
	unlocked_parts += 1

extends Node3D

class_name MapPart

@onready
var game_manager : GameManager = get_node("/root/GameManager")

func _on_interactable_interact():
	game_manager.map_collected()
	$AudioStreamPlayer3D.play()
	$Interactable.active = false
	hide()


func _on_audio_stream_player_3d_finished():
	get_parent_node_3d().remove_child(self)

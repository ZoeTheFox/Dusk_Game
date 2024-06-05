extends Node3D

@export
var name_on_grave : String

func _on_interactable_interact():
	$TextDisplay.show_text(name_on_grave)

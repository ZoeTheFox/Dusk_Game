extends Node3D

@export
var name_on_grave : String = "Default Name"

@export
var death_date : String = "January 1st 1970"

@export
var note : String = "No Notes"

func _on_interactable_interact():
	$TextDisplay.show_text(name_on_grave + ". Died " + death_date + ". " + note + ".")

extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interact():
	var heading = round(get_parent_node_3d().value)
	
	var text = "Heading to " + str(heading) + "°. Facing " + getDirection(heading) + "."
	
	$TextDisplay.show_text(text)

# Function to determine direction based on angle
func getDirection(angle_degrees: float) -> String:
	if (angle_degrees >= 315 or angle_degrees < 45):
		return "North"
	elif angle_degrees < 135:
		return "East"
	elif angle_degrees < 225:
		return "South"
	else:
		return "West"

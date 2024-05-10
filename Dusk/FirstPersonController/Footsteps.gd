extends AudioStreamPlayer3D

var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(player.velocity.length())
	
	if player.velocity.length() > 0 and player.is_on_floor():
		pitch_scale = randf_range(0.6, 1)
		if (!playing):
			play()
	else:
		stop()
		

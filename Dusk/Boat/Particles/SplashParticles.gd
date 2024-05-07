extends Node3D


@export
var animation_controller : Node3D

@onready
var splashes : Array = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	print(animation_controller.speed)
	
	if animation_controller.speed > 1:
		var random_index = randi() % splashes.size()

		# Play the animation for the selected splash
		var splash_node = splashes[random_index]
		splash_node.play_animation(animation_controller.speed)  # Replace with the actual method name

		# Adjust the frequency based on animation_controller.speed
		var min_delay = 0.1  # Minimum delay between animations
		var max_delay = 3.0  # Maximum delay between animations
		var delay = lerp(min_delay, max_delay, animation_controller.speed / 6 )
		await get_tree().create_timer(animation_controller.speed * 2 / 3).timeout


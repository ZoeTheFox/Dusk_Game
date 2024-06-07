extends Node3D

@onready
var lamp : MeshInstance3D = $Lamp2

# Called when the node enters the scene tree for the first time.
func _ready():
	print(lamp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turn_off():
	lamp.material_override.energy_strength = 0
	
	
func turn_on():
	lamp.material_override.energy_strength = 11

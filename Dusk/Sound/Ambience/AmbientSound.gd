extends Node3D

class_name AmbientSoundPlayer

@onready
var ocean_sounds : AudioStreamPlayer = $OceanSounds

@onready
var wind_sounds : AudioStreamPlayer = $WindSounds

@onready
var rain_sounds : AudioStreamPlayer = $RainSounds

@export
var min_volume_db : float
@export
var max_volume_db : float
@export
var min_distance : float
@export
var max_distance : float

var ocean_distance : float
var island_distance : float

# Called when the node enters the scene tree for the first time.
func _ready():
	ocean_sounds.play()
	wind_sounds.play()
	rain_sounds.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_volume(ocean_sounds, island_distance)

func set_volume(player : AudioStreamPlayer, distance : float) -> void:
	var distance_normalized : float = (distance - min_distance) / (max_distance - min_distance)
	
	distance_normalized = clampf(distance_normalized, 0, 1)
	
	player.volume_db = lerpf(min_volume_db, max_volume_db, distance_normalized)

	#print("D: " + str(distance) + " N: " + str(distance_normalized) + "db: " + str(player.volume_db))

func set_muffled(state : bool):
	if (state):
		ocean_sounds.bus = "Muffle"
		wind_sounds.bus = "Muffle"
		rain_sounds.bus = "Muffle"
	else:
		ocean_sounds.bus = "Environment"
		wind_sounds.bus = "Environment"
		rain_sounds.bus = "Environment"

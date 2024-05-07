extends GPUParticles3D

@onready
var audio = $AudioStreamPlayer3D

@export
var min_dB : float

@export
var max_dB : float

func play_animation(speed : float):
	audio.pitch_scale = randf_range(0.7, 1.2)
	audio.volume_db = lerp(min_dB, max_dB, speed / 5.0)
	audio.play()
	emitting = true

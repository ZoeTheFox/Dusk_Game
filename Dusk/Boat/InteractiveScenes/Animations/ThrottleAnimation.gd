extends Node3D


var throttle : float = 0

var last_throttle : float = 0

var throttle_delta : float

@onready
var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready
var animation : AnimationPlayer = $AnimationPlayer

var can_play_wheel_audio : bool

func _process(delta):
	var throttle_node = $ThrottleBase/ThrottleStick
	
	throttle_delta = last_throttle - throttle
	
	throttle_node.rotation.z = deg_to_rad(90 + 30 * -throttle)
	
	
	last_throttle = throttle
	
	print(throttle_delta)
	
	if (abs(throttle_delta) > 0.008):
		start_throttle_audio()
	else:
		stop_throttle_audio()


func start_throttle_audio():
	if (can_play_wheel_audio):
		audio.pitch_scale = randf_range(0.6, 0.8)
		animation.play("wheel_turn_audio_start")
		audio.play()
		can_play_wheel_audio = false

func stop_throttle_audio():
	animation.play("wheel_turn_audio_stop")
	can_play_wheel_audio = true


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "wheel_turn_audio_stop"):
		audio.stop()
	

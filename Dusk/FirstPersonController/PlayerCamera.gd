extends Node3D

@export
var enable : bool

@export
var amplitude : float = 0.015

@export
var frequency : float = 10.0

@export
var camera : Camera3D

@export
var head : Node3D

@export
var twist_pivot : Node3D

@export
var player : CharacterBody3D

@export
var toggle_speed : float = 3.0


var start_pos : Vector3

# https://www.youtube.com/watch?v=5MbR2qJK8Tc

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = camera.position
	reset_position()
	
func _process(delta):
	if (!enable):
		return
	
	check_motion()
	reset_position()
	#camera.look_at(focus_target())
	
	#print(focus_target())

func focus_target() -> Vector3:
	var pos = Vector3(global_position.x, global_position.y * head.position.y, global_position.z)
	pos += twist_pivot.transform.basis.z * 15.0
	
	return pos

func foot_step_motion() -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y += sin(Time.get_ticks_msec() * frequency) * amplitude
	pos.x += cos(Time.get_ticks_msec() * frequency / 2.0) * amplitude * 2
	
	print(pos)
	
	return pos
	
func check_motion() -> void:
	var speed = Vector3(player.velocity.x, 0, player.velocity.z).length()
	
	if (speed < toggle_speed):
		return
	
	if (!player.is_on_floor()):
		return
		
	play_motion(foot_step_motion())

func reset_position() -> void:
	if (camera.position == start_pos):
		return
		
	camera.position = lerp(camera.position, start_pos, 1 * get_process_delta_time())
	
	

func play_motion(motion : Vector3) -> void:
	camera.position += motion * 0.5
	#camera.position = lerp(camera.position, motion, 1 * get_process_delta_time())

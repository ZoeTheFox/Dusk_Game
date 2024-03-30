extends Node3D

@onready
var animation_controller = $AnimationController

@onready
var boat_rigidbody = $ShipHull

@onready
var throttle_dead_zone_timer : Timer = $Timers/ThrottleDeadzoneTimer

@onready
var player_spawn_location = $ShipHull/PlayerSpawn

@export_category("Engine Parameters")

@export_range(0, 10000)
var max_engine_rpm : float = 6000

@export
var idle_rpm : float = 1000

@export
var max_engine_force : float = 3000

@export
var max_turning_force : float = 250

@export
var engine_force : Curve

@export_category("Throttle Parameters")

var throttle : float = 0

@export
var throttle_sensitivity : float = 0.5

@export
var throttle_deadzone : float = 0.1

var engine_rpm : float
var wheel_turn : float = 0

var engine_on : bool = false
var engine_off : bool = true
var clutch_active : bool

var is_player_seated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShipHull/Mesh/Interior/RPM_Gauge.max_value = max_engine_rpm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var throttle_input : float = 0
	
	if (is_player_seated):
		throttle_input = Input.get_axis("throttle_backwards", "throttle_forwards");
	
	throttle += throttle_input * delta * throttle_sensitivity
	throttle = clampf(throttle, -1, 1)
	
	# Throttle Deadzone
	# When throttle value is in the deadzone, timer starts and sets throttle to zero after finishing
	if ((throttle <= throttle_deadzone and throttle >= -throttle_deadzone) and throttle != 0):
		if (throttle_dead_zone_timer.is_stopped()):
			throttle_dead_zone_timer.start()
			
	if (throttle == 0):
		clutch_active = true
	else:
		clutch_active = false
	
	# Temporary Code
	if (Input.is_key_pressed(KEY_R) and engine_off == true and is_player_seated):
		start_engine()
	
	if (Input.is_key_pressed(KEY_T) and engine_off == false and engine_on == true and is_player_seated):
		stop_engine()
	
	if (engine_on == true and engine_off == false):
		engine_rpm = lerpf(engine_rpm, calculate_rpm_from_throttle(throttle), delta / 4)
		
	var turn_input : float = 0
	
	if (is_player_seated):
		turn_input = Input.get_axis("turn_left", "turn_right")
	
	wheel_turn = lerpf(wheel_turn, turn_input, delta * 2)
	
	update_animations()

func _physics_process(delta):
	if (clutch_active == false):
		var engine_rpm_normalized = engine_rpm / max_engine_rpm
		
		var force = max_engine_force * engine_force.sample(engine_rpm_normalized)
		
		if (throttle > 0):
			boat_rigidbody.apply_central_force(-boat_rigidbody.transform.basis.x * force)
		else:
			boat_rigidbody.apply_central_force(boat_rigidbody.transform.basis.x * force)
	
	boat_rigidbody.apply_torque_impulse(boat_rigidbody.transform.basis.y * -wheel_turn * max_turning_force * boat_rigidbody.linear_velocity.length())
	
	boat_rigidbody.rotation_degrees.x = lerpf(boat_rigidbody.rotation_degrees.x, wheel_turn * max_turning_force * 0.0003 * boat_rigidbody.linear_velocity.length(), delta / 2)

func update_animations() -> void:
	animation_controller.throttle = throttle
	animation_controller.rpm = engine_rpm
	animation_controller.wheel_turn = wheel_turn
	animation_controller.speed = boat_rigidbody.linear_velocity.length()
	animation_controller.fuel = 50
	animation_controller.heading = boat_rigidbody.rotation_degrees.y

func calculate_rpm_from_throttle(throttle : float) -> float:
	return lerpf(idle_rpm, max_engine_rpm, abs(throttle))

func start_engine() -> void:
	var start_engine_thread : Thread = Thread.new()
	engine_on = true
	start_engine_thread.start(start_engine_animation_thread)
	$ShipHull/Mesh/cabin/radar.radar_on = true

func start_engine_animation_thread() -> void:
	while engine_rpm < idle_rpm - 50.0:
		engine_rpm = lerpf(engine_rpm, idle_rpm, get_process_delta_time())
		await get_tree().create_timer(0.02).timeout
	
	engine_rpm = idle_rpm
	engine_off = false

func stop_engine() -> void:
	var stop_engine_thread : Thread = Thread.new()
	engine_on = false
	stop_engine_thread.start(stop_engine_animation_thread)
	$ShipHull/Mesh/cabin/radar.radar_on = false

func stop_engine_animation_thread() -> void:
	while engine_rpm > 100:
		engine_rpm = lerpf(engine_rpm, 0, get_process_delta_time())
		await get_tree().create_timer(0.02).timeout
	
	engine_rpm = 0
	engine_off = true

func _on_throttle_deadzone_timer_timeout():
	if (throttle <= throttle_deadzone and throttle >= -throttle_deadzone):
		throttle = 0

func enter_boat():
	$ShipHull/Camera/TwistPivot/PitchPivot/BoatCamera.current = true
	is_player_seated = true

func exit_boat():
	$ShipHull/Camera/TwistPivot/PitchPivot/BoatCamera.current = false
	is_player_seated = false

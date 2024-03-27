extends Node3D


@export
var animation_controller : Node3D

@export
var boat_rigidbody : RigidBody3D

@export_range(0, 10000)
var max_engine_rpm : float = 6000

var engine_rpm : float

@export
var idle_rpm : float = 1000

@export
var max_engine_force : float = 3000

@export
var throttle_change_sensitivity : float = 0.5

var engine_on : bool = false
var engine_off : bool = true

var clutch_on : bool

var throttle : float = 0

@export
var throttle_deadzone : float = 0.1

@onready
var throttle_dead_zone_timer : Timer = $Timers/ThrottleDeadzoneTimer


var wheel_turn : float = 0

@export
var wheel_deadzone : float = 0.1

@export
var engine_force : Curve

@export
var turning_force : float = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var throttle_input : float
	
	throttle_input = Input.get_axis("throttle_backwards", "throttle_forwards");
	
	throttle += throttle_input * delta * throttle_change_sensitivity

	if ((throttle <= throttle_deadzone and throttle >= -throttle_deadzone) and throttle != 0):
		if (throttle_dead_zone_timer.is_stopped()):
			throttle_dead_zone_timer.start()
			
	if (throttle == 0):
		clutch_on = true
		
	else:
		clutch_on = false
		
	throttle = clampf(throttle, -1, 1)
	
	
	if (Input.is_key_pressed(KEY_R) and engine_off == true):
		start_engine()
	
	if (Input.is_key_pressed(KEY_T) and engine_off == false and engine_on == true):
		stop_engine()
	
	if (engine_on == true and engine_off == false):
		engine_rpm = lerpf(engine_rpm, calculate_rpm_from_throttle(throttle), delta / 4)
		
	var turn_input : float
	
	turn_input = Input.get_axis("turn_left", "turn_right")
	
	wheel_turn = lerpf(wheel_turn, turn_input, delta * 2)
	
	update_animations()

func _physics_process(delta):
	if (clutch_on == false):
		var engine_rpm_normalized = engine_rpm / max_engine_rpm
		
		var force = max_engine_force * engine_force.sample(engine_rpm_normalized)
		
		print("force: " + str(force) + " N")
		
		if (throttle > 0):
			boat_rigidbody.apply_central_force(-boat_rigidbody.transform.basis.x * force)
		else:
			boat_rigidbody.apply_central_force(boat_rigidbody.transform.basis.x * force)
	
	boat_rigidbody.apply_torque_impulse(boat_rigidbody.transform.basis.y * -wheel_turn * turning_force * boat_rigidbody.linear_velocity.length())

func update_animations() -> void:
	animation_controller.throttle = throttle
	animation_controller.rpm = engine_rpm
	animation_controller.wheel_turn = wheel_turn
	animation_controller.speed = boat_rigidbody.linear_velocity.length()
	print(boat_rigidbody.linear_velocity.length())
	animation_controller.fuel = 80

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
	
	engine_rpm = 1000
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



func _on_wheel_deadzone_timer_timeout():
	pass # Replace with function body.

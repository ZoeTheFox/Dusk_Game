extends CharacterBody3D

@export_category("Mouse Settings")
@export
var mouse_sensivity := 0.001

var twist_input := 0.0
var pitch_input := 0.0


@export_category("Speed")

@export
var walking_speed = 3.0

@export
var running_speed = 5.0

@export
var jump_velocity = 4.5

@export_category("Acceleration")

@export
var acceleration = 12

@export
var decceleration = 8.0

@export_category("Camera Pivots")

@export
var twist_pivot : Node3D

@export
var pitch_pivot : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export
var camera : Camera3D

@export_category("Player Boat")

@export
var boat : Node3D

var is_in_ship : bool = false

var is_on_ship : bool = false

func _physics_process(delta):
	if (Input.is_action_just_released("interact")):
		if (is_in_ship):
			exit_ship()
			boat.exit_boat()
		else:
			enter_ship()
			boat.enter_boat()
	
	if (is_in_ship):
		return
	
	var speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	
	if (Input.is_action_pressed("run")):
		speed = running_speed
	
	var direction = (transform.basis * twist_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * speed
	
	if (is_on_floor()):
		velocity.x = lerp(velocity.x, target_velocity.x, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))
		velocity.z = lerp(velocity.z, target_velocity.z, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))

	if (is_on_ship):
		pass
	
	move_and_slide()
	
# Called when the node enters the scene tree for tshe first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var boat_area = boat.get_node("ShipHull/BoatArea")
	
	boat_area.connect("body_entered", _on_body_entered)
	boat_area.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	is_on_ship = true
	
func _on_body_exited(body):
	is_on_ship = false

func enter_ship():
	camera.current = false
	is_in_ship = true
	
	global_position = Vector3(-10000, 0, 10000000)

func exit_ship():
	camera.current = true
	is_in_ship = false
	
	global_position = boat.player_spawn_location.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	
	twist_input = 0
	pitch_input = 0
	
func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity

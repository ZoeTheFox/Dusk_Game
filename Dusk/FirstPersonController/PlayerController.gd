extends CharacterBody3D

@export
var mouse_sensivity := 0.001

var twist_input := 0.0
var pitch_input := 0.0



@export
var walking_speed = 3.0

@export
var running_speed = 5.0

@export
var jump_velocity = 4.5

@export
var acceleration = 5.0

@export
var decceleration = 5.0

@export
var twist_pivot : Node3D

@export
var pitch_pivot : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export
var camera : Camera3D

func _physics_process(delta):
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
	
	var direction = (transform.basis * camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * speed
	
	if (is_on_floor()):
		velocity.x = lerp(velocity.x, target_velocity.x, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))
		velocity.z = lerp(velocity.z, target_velocity.z, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))
	
	#if (is_on_floor() and velocity.length() > 0):
		#camera.head_bobbing(10)
	
	print(target_velocity)
	print(velocity)
	
	print(is_on_floor())
	
	move_and_slide()
	
# Called when the node enters the scene tree for tshe first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
		
	twist_input = 0
	pitch_input = 0
	
func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity

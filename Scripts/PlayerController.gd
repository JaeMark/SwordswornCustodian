extends CharacterBody3D

@export var speed = 10.0
@export var acceleration = 4.0
@export var jump_speed = 8.0
@export var rotation_speed = 5.0
@export var camera_lag = 0.1 # Adjust this value to control the camera lag

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $KnightBlue

var target_rotation = 0.0
var target_spring_rotation = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Handle rotation based on input.
	var input_dir = Input.get_vector("left", "right", "forward", "back")

	# Rotate the player left or right
	if input_dir.x != 0:
		model.rotation.y += input_dir.x * rotation_speed * delta
		target_spring_rotation += input_dir.x * rotation_speed * delta

	spring_arm.rotation.y = lerp_angle(spring_arm.rotation.y, target_spring_rotation, camera_lag)

	handle_movement_input(delta)
	move_and_slide()

func handle_movement_input(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")

	# Calculate the movement direction based on player's rotation
	var direction = Vector3(0, 0, 1).rotated(Vector3.UP, model.rotation.y)
	
	# Adjust the velocity based on the input
	var velocity_y = velocity.y;
	velocity = lerp(velocity, direction * input_dir.y * speed, acceleration * delta)
	velocity.y = velocity_y

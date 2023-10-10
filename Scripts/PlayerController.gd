extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	handle_movement_input(delta)
	###
	#if direction:
	#	velocity.x = direction.x * SPEED
	#	velocity.z = direction.z * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	velocity.z = move_toward(velocity.z, 0, SPEED)
	###
	move_and_slide()

func handle_movement_input(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, spring_arm.rotation.y)
	
	var velocity_y = velocity.y;
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	velocity.y = velocity_y
	

func jump():
	gravity = -jump_speed


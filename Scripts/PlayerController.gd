extends CharacterBody3D

@export var speed = 10.0
@export var acceleration = 4.0
@export var jump_speed = 12.0
@export var max_jump_height = 5.0 
@export var rotation_speed = 3.0
@export var camera_lag = 0.1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $KnightBlue

var target_rotation = 0.0
var target_spring_rotation = 0.0
var jump_start_height = 0.0
var is_jumping = false

func _physics_process(delta):
	if not is_on_floor() and not is_jumping:
		velocity.y -= gravity * jump_speed * delta
	elif Input.is_action_just_pressed("jump"):
		is_jumping = true
		jump_start_height = global_transform.origin.y
		velocity.y = jump_speed

	if is_jumping and Input.is_action_just_released("jump"):
		is_jumping = false
		
	if is_jumping:
		var jump_height = abs(global_transform.origin.y - jump_start_height)
		if jump_height >= max_jump_height:
			velocity.y = 0
			is_jumping = false

	var input_dir = Input.get_vector("left", "right", "forward", "back")

	if input_dir.x != 0:
		model.rotation.y -= input_dir.x * rotation_speed * delta
		target_spring_rotation -= input_dir.x * rotation_speed * delta

	spring_arm.rotation.y = lerp_angle(spring_arm.rotation.y, target_spring_rotation, camera_lag)

	handle_movement_input(delta)
	move_and_slide()

func handle_movement_input(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")

	var direction = Vector3(0, 0, 1).rotated(Vector3.UP, model.rotation.y)
	
	var velocity_y = velocity.y;
	velocity = lerp(velocity, direction * input_dir.y * speed, acceleration * delta)
	velocity.y = velocity_y

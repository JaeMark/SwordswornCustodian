extends CharacterBody3D

signal collectable_collected(collectbaleType : Collectable.CollectableType, num_collected : int)
signal submit_collectables(num_blue_shield : int, num_red_shield : int, num_sword : int)

@export var speed = 10.0
@export var acceleration = 5.0
@export var jump_speed = 10.0
@export var max_jump_height = 5.0 
@export var rotation_speed = 3.0
@export var camera_lag = 0.1
@export var dash_speed_multiplier = 4.0

@export var check_point_audio : AudioStream
@export var death_audio : AudioStream

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $KnightBlue
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer

var target_rotation = 0.0
var target_spring_rotation = 0.0
var jump_start_height = 0.0
var is_jumping = false
var is_dashing = false

var blue_shield_collected = 0
var red_shield_collected = 0
var sword_collected = 0

var spawn_location : Vector3

func _ready():
	spawn_location = self.position

func _physics_process(delta):
	if not is_on_floor() and not is_jumping:
		# Apply gravity when not on the floor and not jumping
		velocity.y -= gravity * jump_speed * delta
	elif Input.is_action_just_pressed("jump"):
		is_jumping = true
		jump_start_height = global_transform.origin.y
		velocity.y = jump_speed

	if is_jumping and Input.is_action_just_released("jump"):
		is_jumping = false
	
	# Check if jump height exceeds maximum
	if is_jumping:
		var jump_height = abs(global_transform.origin.y - jump_start_height)
		if jump_height >= max_jump_height:
			velocity.y = 0
			is_jumping = false
	
	# Handle dash input
	if Input.is_action_pressed("dash") and not is_dashing:
		is_dashing = true
		# Increase speed during dash
		speed *= dash_speed_multiplier  # You can adjust this factor as needed

	if is_dashing and !Input.is_action_pressed("dash"):
		is_dashing = false
		# Reset speed back to normal
		speed /= dash_speed_multiplier
	
	# Get input for movement
	var input = Input.get_vector("left", "right", "forward", "back")
	
	# Calculate movement direction
	var direction = Vector3(0, 0, 1).rotated(Vector3.UP, model.rotation.y)
	var velocity_y = velocity.y; # Save a copy of velocity y
	velocity = lerp(velocity, direction * input.y * speed, acceleration * delta)
	velocity.y = velocity_y # Restore the original vertical velocity. This maintains consistent vertical motion.
	
	# Handle rotation input
	if input.x != 0:
		model.rotation.y -= input.x * rotation_speed * delta
		target_spring_rotation -= input.x * rotation_speed * delta
	spring_arm.rotation.y = lerp_angle(spring_arm.rotation.y, target_spring_rotation, camera_lag)
	
	# Handle interact input
	if Input.is_action_just_released("interact"):
		submit_collectables.emit(blue_shield_collected, red_shield_collected, sword_collected)
	
	# Handle walk animation
	if is_on_floor() and input.x != 0 || input.y !=  0:
		animation_player.play("Walk")
	else:
		animation_player.stop()
		
	move_and_slide()

func set_spawn_point(checkpoint_location : Vector3):
	if checkpoint_location != spawn_location:
		audio_player.stream = check_point_audio
		audio_player.play()
		spawn_location = checkpoint_location
	
func teleport_to_checkpoint():
	audio_player.stream = death_audio
	audio_player.play()
	self.position = spawn_location

func on_collect_collectable(collectableType : Collectable.CollectableType):
	match collectableType:
		Collectable.CollectableType.BlueShield:
			blue_shield_collected += 1
			collectable_collected.emit(collectableType, blue_shield_collected)
			print("Collected blue shield!")
		Collectable.CollectableType.RedShield:
			red_shield_collected += 1
			collectable_collected.emit(collectableType, red_shield_collected)
			print("Collected red shield!")
		Collectable.CollectableType.Sword:
			sword_collected += 1
			collectable_collected.emit(collectableType, sword_collected)
			print("Collected sword!")
	

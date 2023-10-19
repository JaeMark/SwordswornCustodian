extends Node3D

signal open_gate
signal level_complete

@export var required_blue_shield = 2
@export var required_red_shield = 1
@export var required_sword = 3
@export var player : CharacterBody3D

@export var request_incomplete_audio : AudioStream
@export var request_complete_audio : AudioStream
@export var hurt_audio : AudioStream

@onready var king_request_ui = $SubViewport/KingRequestUI
@onready var king_submit_ui = $SubViewport2/SubmitUI
@onready var king_level_complete_ui_sprite = $KingMesh/LevelCompleteUI
@onready var king_mesh = $KingMesh
@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D

var is_request_fulfilled := false;
var is_player_in_sight := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup UI request count
	king_request_ui.update_request_amount(Collectable.CollectableType.BlueShield, required_blue_shield)
	king_request_ui.update_request_amount(Collectable.CollectableType.RedShield, required_red_shield)
	king_request_ui.update_request_amount(Collectable.CollectableType.Sword, required_sword)

func _process(delta):
	if is_player_in_sight and player:
		king_mesh.look_at(player.position, Vector3(0,1,0))
		king_mesh.rotation.x = 0 # Make sure king does not look up

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		is_player_in_sight = true
	
func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		is_player_in_sight = false

func _on_player_submit_collectables(num_blue_shield, num_red_shield, num_sword):
	is_request_fulfilled = num_blue_shield >= required_blue_shield and num_red_shield >= required_red_shield and num_sword >= required_sword
	if is_player_in_sight:
		if is_request_fulfilled:
			audio_player.stream = request_complete_audio
			audio_player.play()
			
			handle_successful_cleanup()
		else:
			audio_player.stream = request_incomplete_audio
			audio_player.play()

func handle_successful_cleanup():
	animation_player.play("cheer")
	open_gate.emit()
	level_complete.emit()
	
	king_request_ui.visible = false
	king_submit_ui.visible = false
	king_level_complete_ui_sprite.visible = true
	
func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		audio_player.stream = hurt_audio
		audio_player.play()

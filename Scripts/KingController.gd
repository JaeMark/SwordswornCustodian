extends Node3D

signal open_gate

@export var required_blue_shield = 2
@export var required_red_shield = 1
@export var required_sword = 3
@export var player : CharacterBody3D

@onready var king_request_ui = $SubViewport/KingRequestUI
@onready var king_submit_ui = $SubViewport2/SubmitUI
@onready var king_level_complete_ui_sprite = $KingMesh/LevelCompleteUI
@onready var king_mesh = $KingMesh
@onready var animation_player = $AnimationPlayer

var is_request_fulfilled := false;
var is_player_in_sight := false;

# Called when the node enters the scene tree for the first time.
func _ready():
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


func _on_player_interact_input_pressed():
	if is_player_in_sight and is_request_fulfilled:
		open_gate.emit()


func _on_player_submit_collectables(num_blue_shield, num_red_shield, num_sword):
	is_request_fulfilled = num_blue_shield >= required_blue_shield and num_red_shield >= required_red_shield and num_sword >= required_sword
	if is_player_in_sight and is_request_fulfilled:
		handle_successful_cleanup()

func handle_successful_cleanup():
	open_gate.emit()
	king_request_ui.visible = false
	king_submit_ui.visible = false
	king_level_complete_ui_sprite.visible = true
	animation_player.play("cheer")
	

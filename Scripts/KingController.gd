extends Node3D

@export var required_blue_shield = 2
@export var required_red_shield = 1
@export var required_sword = 3

@onready var king_ui = $SubViewport/KingRequestUI

var is_request_fulfilled := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	king_ui.update_request_amount(Collectable.CollectableType.BlueShield, required_blue_shield)
	king_ui.update_request_amount(Collectable.CollectableType.RedShield, required_red_shield)
	king_ui.update_request_amount(Collectable.CollectableType.Sword, required_sword)

func check_request(num_blue_shield : int, num_red_shield : int, num_sword : int) :
	is_request_fulfilled = num_blue_shield >= required_blue_shield && num_red_shield >= required_red_shield && num_sword >= required_sword



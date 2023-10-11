extends Node3D


@export var required_blue_shield = 2
@export var required_red_shield = 1
@export var required_sword = 3

@onready var king_ui = $SubViewport/KingRequestUI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	king_ui.update_request_amount(Collectable.CollectableType.BlueShield, required_blue_shield)
	king_ui.update_request_amount(Collectable.CollectableType.RedShield, required_red_shield)
	king_ui.update_request_amount(Collectable.CollectableType.Sword, required_sword)
	pass



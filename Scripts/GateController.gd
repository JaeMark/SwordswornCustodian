extends Node3D

@onready var animation_player = $AnimationPlayer

func _open_gate():
	animation_player.play("gate_open")

func _on_king_open_gate():
	_open_gate()

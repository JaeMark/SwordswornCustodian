extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D

func _open_gate():
	animation_player.play("gate_open")
	audio_player.play()

func _on_king_open_gate():
	_open_gate()

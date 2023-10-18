extends Area3D

@export var spawn_point : MeshInstance3D

func _on_body_entered(body):
	if body.is_in_group("Player") and spawn_point:
		body.position = spawn_point.position

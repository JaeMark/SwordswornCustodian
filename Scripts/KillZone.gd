extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("teleport_to_checkpoint"):
		body.teleport_to_checkpoint()

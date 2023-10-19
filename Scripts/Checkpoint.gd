extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("set_spawn_point"):
		body.set_spawn_point(self.position)

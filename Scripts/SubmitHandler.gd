extends Area3D

@onready var submit_sprite = $SubmitSprite

func _on_body_entered(body):
	if body.is_in_group("Player"):
		submit_sprite.visible = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		submit_sprite.visible = false

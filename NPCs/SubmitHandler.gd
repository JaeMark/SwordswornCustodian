extends Area3D

@onready var king = $King
@onready var submit_sprite = $SubmitSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		submit_sprite.visible = true


func _on_body_exited(body):
	if body.is_in_group("Player"):
		submit_sprite.visible = false

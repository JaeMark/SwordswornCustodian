extends Area3D

@export var rotation_speed = 1.0

@onready var mesh = $MeshInstance3D

func _on_body_entered(body):
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(rotation_speed * delta) # Rotation


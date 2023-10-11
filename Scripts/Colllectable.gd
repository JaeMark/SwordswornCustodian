extends Area3D

class_name Collectable

@export var rotation_speed = 1.0
@export var collectableType = CollectableType.BlueShield

@onready var mesh = $MeshInstance3D

enum CollectableType {
	BlueShield,
	RedShield,
	Sword
}

func _on_body_entered(body):
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(rotation_speed * delta) # Rotation


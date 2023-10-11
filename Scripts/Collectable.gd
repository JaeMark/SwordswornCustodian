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

var is_collected := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(rotation_speed * delta) # Rotation

func _on_body_entered(body):
	print("Collected!")
	if body.is_in_group("Player"):
		body.on_collect_collectable(collectableType)
		
		self.queue_free()
		is_collected = true;

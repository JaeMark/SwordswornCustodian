extends Area3D

class_name Collectable

@export var rotation_speed = 1.0
@export var collectableType = CollectableType.BlueShield

@onready var mesh = $MeshInstance3D
@onready var audio_player = $AudioStreamPlayer3D
@onready var timer = $Timer

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
	if body.is_in_group("Player") and not is_collected:
		audio_player.play()
		body.on_collect_collectable(collectableType)
		
		self.visible = false
		is_collected = true  
		set_process(false)  # Disable further processing
		
		timer.start()  # Start a timer to remove the object after some time

func _on_Timer_timeout():
	queue_free()  # Remove the object



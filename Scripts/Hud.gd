extends CanvasLayer

@onready var blue_shield_text = $BlueShield/BlueShieldCount
@onready var red_shield_text = $RedShield/RedShieldCount
@onready var sword_text = $Sword/SwordCount

func _on_player_collectable_collected(collectbaleType, num_collected):
	print("UI update")
	match collectbaleType:
		Collectable.CollectableType.BlueShield:
			blue_shield_text.text = str(num_collected)
		Collectable.CollectableType.RedShield:
			red_shield_text.text = str(num_collected)
		Collectable.CollectableType.Sword:
			sword_text.text = str(num_collected)

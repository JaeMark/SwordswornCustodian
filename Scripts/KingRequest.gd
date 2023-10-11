extends Control

@onready var blue_shield_text = $BlueShieldCount
@onready var red_shield_text = $RedShieldCount
@onready var sword_text = $SwordCount

func update_request_amount(collectbaleType, num_collected):
	match collectbaleType:
		Collectable.CollectableType.BlueShield:
			blue_shield_text.text = str(num_collected)
		Collectable.CollectableType.RedShield:
			red_shield_text.text = str(num_collected)
		Collectable.CollectableType.Sword:
			sword_text.text = str(num_collected)

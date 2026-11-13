extends Area3D
var equipmentGenerator: EquipmentItemGenerator = EquipmentItemGenerator.new()
var treasure:Equipment

func _ready() -> void:
	$Button.disabled = true
	$Button.visible = false
	treasure = equipmentGenerator.generateRandomEquipment(GlobalManager.dungeonRes.dungeonLevel)
	match treasure.equipType:
		GlobalData.equipmentType.WEAPON:
			$Button.text = "GOT " + treasure.itemName + " THE WEAPON!\n(CLICK TO DISMISS)"
		GlobalData.equipmentType.ARMOR:
			$Button.text = "GOT " + treasure.itemName + " THE ARMOR!\n(CLICK TO DISMISS)"
		GlobalData.equipmentType.ACCESSORY:
			$Button.text = "GOT " + treasure.itemName + " THE ACCESSORY!\n(CLICK TO DISMISS)"

func _on_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name == "PlayerControlledCharacter":
		$Button.disabled = false
		$Button.visible = true
		


func _on_button_pressed() -> void:
	GlobalManager.equipmentInventoryArray.append(treasure)
	queue_free()

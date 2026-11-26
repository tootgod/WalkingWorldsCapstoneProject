extends "res://Scripts/BattleSystemManager.gd"
var equipmentGenerator: EquipmentItemGenerator = EquipmentItemGenerator.new()
func endBattleWin():
	var i:int = 1
	for ene in enemyArray:
		var reward = ene.getXpRewards()
		if GlobalManager.playerCharacter1 != null:
			GlobalManager.playerCharacter1.currentExperience += reward
			GlobalManager.playerCharacter1.currentHealth = $Player_battle_Character.currentHealth
			GlobalManager.playerCharacter1.currentMana = $Player_battle_Character.currentMana
		if GlobalManager.playerCharacter2 != null:
			GlobalManager.playerCharacter2.currentExperience += reward
			GlobalManager.playerCharacter2.currentHealth = $Player_battle_Character2.currentHealth
			GlobalManager.playerCharacter2.currentMana = $Player_battle_Character2.currentMana
		if GlobalManager.playerCharacter3 != null:
			GlobalManager.playerCharacter3.currentExperience += reward
			GlobalManager.playerCharacter3.currentHealth = $Player_battle_Character3.currentHealth
			GlobalManager.playerCharacter3.currentMana = $Player_battle_Character3.currentMana
		var mat: = materialItemGenerator.getRandomMaterial()
		var textNode:Label= get_node("CanvasLayer/Text Panel/RewardText1")
		textNode.text = "You got 4 " + mat.itemName + "!"
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		mat = materialItemGenerator.getRandomMaterial()
		textNode = get_node("CanvasLayer/Text Panel/RewardText2")
		textNode.text = "You got 4 " + mat.itemName + "!"
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		mat = materialItemGenerator.getRandomMaterial()
		textNode = get_node("CanvasLayer/Text Panel/RewardText3")
		textNode.text = "You got 4 " + mat.itemName + "!"
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		GlobalManager.addMaterialItemToInventory(mat)
		i+=1
		var treasure:Equipment = equipmentGenerator.generateRandomEquipment(GlobalManager.dungeonRes.dungeonLevel)
		match treasure.equipType:
			GlobalData.equipmentType.WEAPON:
				$"CanvasLayer/Text Panel/RewardText4".text = "GOT " + treasure.itemName + " THE WEAPON!\n(CLICK TO DISMISS)"
			GlobalData.equipmentType.ARMOR:
				$"CanvasLayer/Text Panel/RewardText4".text = "GOT " + treasure.itemName + " THE ARMOR!\n(CLICK TO DISMISS)"
			GlobalData.equipmentType.ACCESSORY:
				$"CanvasLayer/Text Panel/RewardText4".text = "GOT " + treasure.itemName + " THE ACCESSORY!\n(CLICK TO DISMISS)"
		GlobalManager.equipmentInventoryArray.append(treasure)
	$"CanvasLayer/Text Panel".visible = true
	await get_tree().create_timer(5.0).timeout
	GlobalManager.unloadBattle()

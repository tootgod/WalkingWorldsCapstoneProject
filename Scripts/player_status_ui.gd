extends Control

func UpdateHP(currentHP:int,maxHp:int):
	$HPLabel.text = "HP: " + str(currentHP) + "/" + str(maxHp)

func UpdateMP(currentMP:int,maxMP:int):
	$MPLabel.text = "MP: " + str(currentMP) + "/" + str(maxMP)
	
func UpdateName(newName:String):
	$Name.text = newName

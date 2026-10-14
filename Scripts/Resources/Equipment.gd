class_name Equipment
extends Resource

@export var itemName:String
@export var costArray:Array[MaterialCost]
@export var passiveEffect:PassiveAbility
@export var equipType:GlobalData.equipmentType
##Level 0 means item is a blueprint
@export var equipmentLevel:int
@export var rarity:GlobalData.rarityTiers

##equipment gives a bonus to the stat indicated
@export_group("Bonus Battle Stats")
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusDefense :int = 0:
	get:
		return processBonus(bonusDefense)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusMaxHealth :int = 0:
	get:
		return processBonus(bonusMaxHealth)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusMaxMana :int = 0:
	get:
		return processBonus(bonusMaxMana)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusWillpower :int = 0:
	get:
		return processBonus(bonusWillpower)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusStrength :int = 0:
	get:
		return processBonus(bonusStrength)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusIntelligence :int = 0:
	get:
		return processBonus(bonusIntelligence)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusSpeed :int = 0:
	get:
		return processBonus(bonusSpeed)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusLuck :int = 0:
	get:
		return processBonus(bonusLuck)

func processBonus(value:int)->int:
	if equipmentLevel == 0:
		return value
	else:
		return value +(0.3*(value ** (equipmentLevel - 1)))

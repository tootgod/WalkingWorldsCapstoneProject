class_name Equipment
extends Resource


@export var itemName:String
@export_range(1, 99) var weaponRank: int = 1
##This contains the amount of materials needed as well as the material itself[br]
##If there are more then 3 costs, any after 3 will be ignored
@export var costArray:Array[MaterialCost]
#@export var passiveEffect:PassiveAbility
@export var equipType:GlobalData.equipmentType
##Level 0 means item is a blueprint
@export var equipmentLevel:int = 1
#@export var rarity:GlobalData.rarityTiers
@export var sprite:Texture2D = preload("res://icon.svg")

##equipment gives a bonus to the stat indicated
@export_group("Bonus Battle Stats")
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increase based on level
@export var bonusDefense :int = 0:
	get:
		return processBonus(bonusDefense)
	set(value):
		bonusDefense = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusMaxHealth :int = 0:
	get:
		return processBonus(bonusMaxHealth)
	set(value):
		bonusMaxHealth = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusMaxMana :int = 0:
	get:
		return processBonus(bonusMaxMana)
	set(value):
		bonusMaxMana = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusWillpower :int = 0:
	get:
		return processBonus(bonusWillpower)
	set(value):
		bonusWillpower = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusStrength :int = 0:
	get:
		return processBonus(bonusStrength)
	set(value):
		bonusStrength = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusIntelligence :int = 0:
	get:
		return processBonus(bonusIntelligence)
	set(value):
		bonusIntelligence = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusSpeed :int = 0:
	get:
		return processBonus(bonusSpeed)
	set(value):
		bonusSpeed = max(0,value)
##equipment gives a bonus to the stat indicated[br]
##Returns base stats if level 0, but otherwise returns the increce based on level
@export var bonusLuck :int = 0:
	get:
		return processBonus(bonusLuck)
	set(value):
		bonusLuck = max(0,value) 

func processBonus(value: int) -> int:
	if equipmentLevel == 0:
		return value
	return int(((value +(0.7*(value * (equipmentLevel - 1)))) * weaponRank) + (2*weaponRank-1) )

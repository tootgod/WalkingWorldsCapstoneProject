class_name MaterialItemGenerator
extends Node

var rng = RandomNumberGenerator.new()

const materialItemArray:Array[MaterialItem]= [preload("res://Resources/MaterialItems/Gemstone.tres"),
			preload("res://Resources/MaterialItems/Gold.tres"),preload("res://Resources/MaterialItems/HeartWood.tres"),
			preload("res://Resources/MaterialItems/Iron.tres"),preload("res://Resources/MaterialItems/MagicSphere.tres"),
			preload("res://Resources/MaterialItems/Vines.tres"),preload("res://Resources/MaterialItems/Wood.tres")]

##Returns a random MaterialItem, with higher tier items being more rare[br]
##If it attepts to return a non MaterialItem, it will always be an Iron
func getRandomMaterial()->MaterialItem:
	var item :MaterialItem= materialItemArray.pick_random()
	if item is MaterialItem:
		match item.rarity:
			GlobalData.rarityTiers.COMMON:
				if rng.randi_range(1,40) == 1:
					item = getRandomMaterial()
			GlobalData.rarityTiers.RARE:
				if rng.randi_range(1,20) == 1:
					item = getRandomMaterial()
			GlobalData.rarityTiers.UNIQUE:
				if rng.randi_range(1,10) == 1:
					item = getRandomMaterial()
			GlobalData.rarityTiers.EPIC:
				if rng.randi_range(1,8) == 1:
					item = getRandomMaterial()
			GlobalData.rarityTiers.LEGENDARY:
				if rng.randi_range(1,5) == 1:
					item = getRandomMaterial()
		return item
	else:
		return preload("res://Resources/MaterialItems/Iron.tres")

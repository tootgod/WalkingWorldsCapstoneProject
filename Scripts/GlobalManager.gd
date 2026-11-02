extends Node

var materialInventoryDictonary:Dictionary[MaterialItem,int]


var stepCount: int=0

var playerCharacter1:CharacterResource = preload("res://Resources/Player1.tres")
var playerCharacter2:CharacterResource = preload("res://Resources/Player2.tres")
var playerCharacter3:CharacterResource = preload("res://Resources/Player3.tres")


func addMaterialItemToInventory(newItem:MaterialItem):
	if materialInventoryDictonary.has(newItem):
		materialInventoryDictonary[newItem] += 1
	else:
		materialInventoryDictonary.get_or_add(newItem,1)

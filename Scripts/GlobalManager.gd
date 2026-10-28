extends Node

var materialInventoryDictonary:Dictionary[MaterialItem,int]

var stepCount: int=0


func addMaterialItemToInventory(newItem:MaterialItem):
	if materialInventoryDictonary.has(newItem):
		materialInventoryDictonary[newItem] += 1
	else:
		materialInventoryDictonary.get_or_add(newItem,1)

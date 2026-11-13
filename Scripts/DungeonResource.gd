class_name DungeonResource
extends Resource

var dungeonLevel:int = 1:
	set(value):
		dungeonLevel = max(1,value)

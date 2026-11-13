class_name DungeonResourceGenerator
extends Node

func generateDungeonResource(dungeonLevel:int)-> DungeonResource:
	var dungeon:DungeonResource = DungeonResource.new()
	dungeon.dungeonLevel = dungeonLevel
	return dungeon

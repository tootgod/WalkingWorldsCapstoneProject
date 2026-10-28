class_name MaterialItem
extends Resource
##Resource representing a resource item used as currencies in the game
@export var sprite:Texture2D = preload("res://icon.svg")
@export var itemName:String
@export var rarity:GlobalData.rarityTiers

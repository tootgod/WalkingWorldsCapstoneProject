class_name Move
extends Resource

@export var name:String
@export var mainAttackType: GlobalData.attackType = GlobalData.attackType.PHYSICAL
@export var secondaryType: GlobalData.secondaryTypes

##if Power is positive, move deals damage, if power is negative, move heals health
@export var power: int
@export var manaCost: int

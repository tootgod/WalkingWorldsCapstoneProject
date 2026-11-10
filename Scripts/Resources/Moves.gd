class_name Move
extends Resource

enum MomentumCosts{ZERO=0,ONE=100,TWO=200,THREE=300}

@export var name:String
@export var mainAttackType: GlobalData.attackType = GlobalData.attackType.PHYSICAL
@export var secondaryType: GlobalData.secondaryTypes

##if Power is positive, move deals damage, if power is negative, move heals health
@export var power: int
@export var manaCost: int
@export var momentumGeneration: int
@export var momentumCost:MomentumCosts

class_name CharacterClass
extends Resource

enum ClassType{PLAYER,ENEMY}

@export var className: String

@export var movesPerLevelDict: Dictionary[int,Move]= {}
@export var potentialPassives:Array[PassiveAbility]= []
@export var secondaryTypeWeaknesses:Array[GlobalData.secondaryTypes] = []
@export var secondaryTypeRes:Array[GlobalData.secondaryTypes] = []

@export var classType: ClassType

@export_group("Battle Stat Growth Rates")
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var defenseGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var healthGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var willpowerGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var strengthGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var intelligenceGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var speedGrowth:float
## Determines how much of a stat a character gains per level.[br]
## Default is 1.0[br]
## A value of 1.0 means one stat every level[br]
## A value of 0.5 means a stat every other level[br]
## A value of 1.5 means one stat every level, with a bonus stat every other level[br]
## Extrapolate from this to get any desired growth rate[br]
@export var luckGrowth:float

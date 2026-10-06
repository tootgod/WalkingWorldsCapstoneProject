extends Node3D
##Manages Turn based combat
##
## This class is going to fufill the bulk of the combat gameplay requirements[br]
## Requirements: BS1, BS3, BS4, BS6, BS7, BS8


@export var current_momentum_amount: float = 0 #goes from 0-3, with whole number increments being used up
@export var active_characters: Array[BattleCharacter]


#the combat should be mostly handled by signals that call the right functions and send any relevant data to where it needs to go
#this class is allowed to be more tied up as it it so central, but try to keep it as general as possible

#TODO: Write code to initalize a fight, currently it only expects premade stuff

func _ready() -> void:
	var chars_in_tree = find_children("BattleCharacter")
	print(chars_in_tree)


func begin_round():
	pass

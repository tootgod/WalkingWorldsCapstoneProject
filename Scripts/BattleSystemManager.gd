extends Node3D
##Manages Turn based combat
##
## This class is going to fufill the bulk of the combat gameplay requirements[br]
## Requirements: BS1, BS3, BS4, BS6, BS7, BS8


@export var current_momentum_amount: float = 0 #goes from 0-3, with whole number increments being used up
@export var active_characters: Array[BattleCharacter]#hold refs to character scenes in the battle


#the combat should be mostly handled by signals that call the right functions and send any relevant data to where it needs to go
#this class is allowed to be more tied up as it it so central, but try to keep it as general as possible

#TODO: Write code to initalize a fight, currently it only expects premade stuff

func _ready() -> void:
	var chars_in_tree = find_children("BattleCharacter")
	$CanvasLayer/MoveSelection.subscribeToAllMovesSendAttack(_on_move_send_attack)


func _on_enemy_battle_character_send_attack(moveToUse: Move, user: BattleCharacter) -> void:
	$Player_battle_Character.reciveAttack(moveToUse,user)
	


func _on_player_battle_character_try_to_attack(moveArray: Array[Move]) -> void:
	$CanvasLayer/MoveSelection.visible = true
	$CanvasLayer/MoveSelection.updateMoveGrid(moveArray)

func _on_move_send_attack(move:Move):
	var inputsignal = await $Enemy_battle_character.input_event
	
	
	while !(inputsignal[1] is InputEventScreenTouch):
		inputsignal = await $Enemy_battle_character.input_event
		

	$Enemy_battle_character.reciveAttack(move,$Player_battle_Character)

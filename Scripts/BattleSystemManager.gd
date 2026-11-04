extends Node3D
##Manages Turn based combat
##
## This class is going to fufill the bulk of the combat gameplay requirements[br]
## Requirements: BS1, BS3, BS4, BS6, BS7, BS8


@export var current_momentum_amount: float = 0 #goes from 0-3, with whole number increments being used up
@export var active_characters: Array[BattleCharacter]#hold refs to character scenes in the battle

var player_move_queue:Array #should only be filled with Array[Move] data
var player_char_move_queue:Array

var enemyArray:Array
var deadEnemies:int


#the combat should be mostly handled by signals that call the right functions and send any relevant data to where it needs to go
#this class is allowed to be more tied up as it it so central, but try to keep it as general as possible

#TODO: Write code to initalize a fight, currently it only expects premade stuff

func _ready() -> void:
	
	$CanvasLayer/MoveSelection.subscribeToAllMovesSendAttack(_on_move_send_attack)
	if GlobalManager.playerCharacter1 != null:
		$Player_battle_Character.characterResource = GlobalManager.playerCharacter1
		active_characters.append($Player_battle_Character)
	else:
		$Player_battle_Character.queue_free()
	if GlobalManager.playerCharacter2 != null:
		$Player_battle_Character2.characterResource = GlobalManager.playerCharacter2
		active_characters.append($Player_battle_Character2)
	else:
		$Player_battle_Character2.queue_free()
	if GlobalManager.playerCharacter3 != null:
		$Player_battle_Character3.characterResource = GlobalManager.playerCharacter3
		active_characters.append($Player_battle_Character3)
	else:
		$Player_battle_Character3.queue_free()
		
	enemyArray.append($Enemy_battle_character)


func _on_enemy_battle_character_send_attack(moveToUse: Move, user: BattleCharacter) -> void:
	var rand_char = active_characters.pick_random()
	while rand_char.dead:
		rand_char = active_characters.pick_random()
	rand_char.reciveAttack(moveToUse,user)
	


func _on_player_battle_character_try_to_attack(moveArray: Array[Move],char) -> void:
	
	if not player_char_move_queue.has(char):
		print("hi")
		player_move_queue.push_back(moveArray)
		player_char_move_queue.push_back(char)
		consumeMoveList()
	
	

func consumeMoveList():
	$CanvasLayer/MoveSelection.visible = true
	$CanvasLayer/MoveSelection.updateMoveGrid(player_move_queue.front())

func _on_move_send_attack(move:Move):
	var inputsignal = await $Enemy_battle_character.input_event
	
	
	while !(inputsignal[1] is InputEventScreenTouch):
		inputsignal = await $Enemy_battle_character.input_event
		

	
	var list = player_move_queue.pop_front()
	
	$CanvasLayer/MoveSelection.resetGrid()
	if list == $Player_battle_Character.moveList and player_char_move_queue.front() == $Player_battle_Character:
		$Player_battle_Character.restartAttackTimer()
		$Enemy_battle_character.reciveAttack(move,$Player_battle_Character)
	if list == $Player_battle_Character2.moveList and player_char_move_queue.front() == $Player_battle_Character2:
		$Player_battle_Character2.restartAttackTimer()
		$Enemy_battle_character.reciveAttack(move,$Player_battle_Character2)
	if list == $Player_battle_Character3.moveList and player_char_move_queue.front()==$Player_battle_Character3:
		$Player_battle_Character3.restartAttackTimer()
		$Enemy_battle_character.reciveAttack(move,$Player_battle_Character3)
	player_char_move_queue.pop_front()
	if not player_move_queue.is_empty():
		consumeMoveList()
	else:
		$CanvasLayer/MoveSelection.visible = false
	
	if $Enemy_battle_character.dead:
		endBattleWin()

func endBattleWin():
	await get_tree().create_timer(5.0).timeout
	GlobalManager.unloadBattle()

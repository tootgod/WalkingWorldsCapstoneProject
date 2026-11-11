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
var battleOver:bool = false

signal lastTappedChanged(lastTap:BattleCharacter)
var lastTapped:BattleCharacter = null:
	set(value):
		lastTapped = value
		lastTappedChanged.emit(lastTapped)
var clearMove:bool = false

var materialItemGenerator:MaterialItemGenerator = MaterialItemGenerator.new()


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
	enemyArray.append($Enemy_battle_character2)
	enemyArray.append($Enemy_battle_character3)


func _on_enemy_battle_character_send_attack(moveToUse: Move, user: BattleCharacter) -> void:
	var i = 0
	var rand_char = active_characters.pick_random()
	while rand_char.dead:
		if i > 1000:
			battleOver = true
			endBattleLose()
		if battleOver:
			return
		rand_char = active_characters.pick_random()
		i+=1
	rand_char.reciveAttack(moveToUse,user)
	


func _on_player_battle_character_try_to_attack(moveArray: Array[Move],char) -> void:
	
	if not player_char_move_queue.has(char) and !char.dead:
		player_move_queue.push_back(moveArray)
		player_char_move_queue.push_back(char)
		consumeMoveList()
	
	

func consumeMoveList():
	$CanvasLayer/MoveSelection.visible = true
	$CanvasLayer/MoveSelection.updateMoveGrid(player_move_queue.front())
	$CanvasLayer/MoveSelection.updateName(player_char_move_queue.front())

func _on_move_send_attack(move:Move):
	clearMove = false
	lastTapped = null
	#var inputsignal = await $Enemy_battle_character.input_event
	#
	#
	#while !(inputsignal[1] is InputEventScreenTouch):
		#inputsignal = await $Enemy_battle_character.input_event
	#while lastTapped == null:
		#if clearMove:
			#clearMove = false
			#return
	await lastTappedChanged
	if player_char_move_queue.front().checkMoveMana(move) and clearMove == false and lastTapped != null:
		
		clearMove = true
		player_char_move_queue.front().removeMana(move)
		
		var list = player_move_queue.pop_front()
		
		$CanvasLayer/MoveSelection.resetGrid()
		if list == $Player_battle_Character.moveList and player_char_move_queue.front() == $Player_battle_Character:
			$Player_battle_Character.restartAttackTimer()
			lastTapped.reciveAttack(move,$Player_battle_Character)
		if list == $Player_battle_Character2.moveList and player_char_move_queue.front() == $Player_battle_Character2:
			$Player_battle_Character2.restartAttackTimer()
			lastTapped.reciveAttack(move,$Player_battle_Character2)
		if list == $Player_battle_Character3.moveList and player_char_move_queue.front()==$Player_battle_Character3:
			$Player_battle_Character3.restartAttackTimer()
			lastTapped.reciveAttack(move,$Player_battle_Character3)
		player_char_move_queue.pop_front()
		if not player_move_queue.is_empty():
			consumeMoveList()
		else:
			$CanvasLayer/MoveSelection.visible = false
		
		for enemy in enemyArray:
			if !enemy.dead:
				return
		endBattleWin()

func endBattleWin():
	for ene in enemyArray:
		var reward = ene.getXpRewards()
		if GlobalManager.playerCharacter1 != null:
			GlobalManager.playerCharacter1.currentExperience += reward
			GlobalManager.playerCharacter1.currentHealth = $Player_battle_Character.currentHealth
			GlobalManager.playerCharacter1.currentMana = $Player_battle_Character.currentMana
		if GlobalManager.playerCharacter2 != null:
			GlobalManager.playerCharacter2.currentExperience += reward
			GlobalManager.playerCharacter2.currentHealth = $Player_battle_Character2.currentHealth
			GlobalManager.playerCharacter2.currentMana = $Player_battle_Character2.currentMana
		if GlobalManager.playerCharacter3 != null:
			GlobalManager.playerCharacter3.currentExperience += reward
			GlobalManager.playerCharacter3.currentHealth = $Player_battle_Character3.currentHealth
			GlobalManager.playerCharacter3.currentMana = $Player_battle_Character3.currentMana
		GlobalManager.addMaterialItemToInventory(materialItemGenerator.getRandomMaterial())
	await get_tree().create_timer(5.0).timeout
	GlobalManager.unloadBattle()

func endBattleLose():
	await get_tree().create_timer(5.0).timeout
	GlobalManager.unloadBattle()

func _on_player_battle_character_hp_change(newCurrentHealth: int, newMaxHealth: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI.UpdateHP(newCurrentHealth,newMaxHealth)

func _on_player_battle_character_2_hp_change(newCurrentHealth: int, newMaxHealth: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI2.UpdateHP(newCurrentHealth,newMaxHealth)

func _on_player_battle_character_3_hp_change(newCurrentHealth: int, newMaxHealth: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI3.UpdateHP(newCurrentHealth,newMaxHealth)

func _on_player_battle_character_mp_change(newCurrentMana: int, newMaxMana: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI.UpdateMP(newCurrentMana,newMaxMana)

func _on_player_battle_character_2_mp_change(newCurrentMana: int, newMaxMana: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI2.UpdateMP(newCurrentMana,newMaxMana)

func _on_player_battle_character_3_mp_change(newCurrentMana: int, newMaxMana: int) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI3.UpdateMP(newCurrentMana,newMaxMana)

func _on_player_battle_character_name_change(newName: String) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI.UpdateName(newName)

func _on_player_battle_character_2_name_change(newName: String) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI2.UpdateName(newName)

func _on_player_battle_character_3_name_change(newName: String) -> void:
	$CanvasLayer/HBoxContainer/PlayerStatusUI3.UpdateName(newName)


func _on_enemy_battle_character_tapped(char: BattleCharacter, event: InputEvent) -> void:
	lastTapped = char


func _on_player_battle_character_downed(battleChar: BattleCharacter) -> void:
	if battleChar == player_char_move_queue.front():
		print(battleChar.displayName + " died") 
		lastTapped = null
		clearMove = true
		player_move_queue.pop_front()
		player_char_move_queue.pop_front()
		consumeMoveList()
	elif player_char_move_queue.has(battleChar):
		print(battleChar.displayName + " died")
		var i = player_char_move_queue.find(battleChar)
		player_char_move_queue.remove_at(i)
		player_move_queue.remove_at(i)
		

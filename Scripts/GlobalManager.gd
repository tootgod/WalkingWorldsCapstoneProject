extends Node

var materialInventoryDictonary:Dictionary[MaterialItem,int]

var charGen:CharacterResourceGenerator = CharacterResourceGenerator.new()
var stepCount: int=0

var playerCharacter1:CharacterResource = charGen.generateRandomCharacter()
var playerCharacter2:CharacterResource = charGen.generateRandomCharacter()
var playerCharacter3:CharacterResource = charGen.generateRandomCharacter()

var oldCamera:Camera3D
var currentBattle:Node3D

signal momentumChanged(newMomentum:int)
var momentum:int:
	set(value):
		momentum = clamp(value,0,300)
		momentumChanged.emit(momentum)

func addMaterialItemToInventory(newItem:MaterialItem):
	if materialInventoryDictonary.has(newItem):
		materialInventoryDictonary[newItem] += 1
	else:
		materialInventoryDictonary.get_or_add(newItem,1)

func loadBattle(battleScene:PackedScene):
	oldCamera = get_viewport().get_camera_3d()
	oldCamera.current = false
	
	if battleScene.can_instantiate():
		currentBattle = battleScene.instantiate()
	get_tree().current_scene.add_child(currentBattle)
	currentBattle.position.y += 1000
	for child in currentBattle.get_children():
		if child is Camera3D:
			child.current = true
			break
	
	
func unloadBattle():
	currentBattle.queue_free.call_deferred()
	oldCamera.current = true

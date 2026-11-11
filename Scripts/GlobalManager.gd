extends Node

const SWORD = preload("res://Resources/sword.tres")
const WAND = preload("res://Resources/wand.tres")
const IRON_ARMOR = preload("res://Resources/iron_armor.tres")
const CRAFTABLE_EQUIPMENT: Array[Equipment] = [SWORD, WAND, IRON_ARMOR]

const IRON = preload("res://Resources/MaterialItems/Iron.tres")
const WOOD = preload("res://Resources/MaterialItems/Wood.tres")
const IRON_WOOD = preload("res://Resources/Materials/IronWood.tres")
const MAGIC_MASTER = preload("res://Resources/Passives/MagicMaster.tres")
const BAR_UPGRADE_COST = 2
const PARTY_LIMIT = 2
const BAR_RECRUITS = {
	&"warrior": {"name": "Warrior", "rank": 1, "passive": null, "material": IRON, "cost": 2},
	&"novice_wizard": {"name": "Novice Wizard", "rank": 1, "passive": MAGIC_MASTER, "material": WOOD, "cost": 2},
	&"mage": {"name": "Mage", "rank": 2, "passive": MAGIC_MASTER, "material": IRON_WOOD, "cost": 2},
}

var barLevel := 1
var hiredRecruits: Array[StringName] = []
var activeCompanions: Array[StringName] = []
var equipmentInventoryArray: Array[Equipment] = []
# Starter supplies until walking and dungeon rewards populate the inventory.
var materialInventoryDictonary: Dictionary[MaterialItem, int] = {
	IRON: 6,
	WOOD: 4,
	IRON_WOOD: 3,
}
var stepCount: int = 0

var charGen:CharacterResourceGenerator = CharacterResourceGenerator.new()

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


var playerLevel: int:
	get:
		return playerCharacter1.currentLevel


func addMaterialItemToInventory(material: MaterialItem) -> void:
	materialInventoryDictonary[material] = materialInventoryDictonary.get(material, 0) + 1


func materialCount(material: MaterialItem) -> int:
	return materialInventoryDictonary.get(material, 0)


func hasMaterials(equipment: Equipment) -> bool:
	for cost in equipment.costArray:
		if materialCount(cost.material) < cost.amount:
			return false
	return true


func spendMaterials(equipment: Equipment) -> void:
	for cost in equipment.costArray:
		materialInventoryDictonary[cost.material] -= cost.amount


func craftEquipment(recipe: Equipment) -> bool:
	if not CRAFTABLE_EQUIPMENT.has(recipe) or playerLevel < recipe.requiredPlayerLevel or not hasMaterials(recipe):
		return false
	var item: Equipment = recipe.duplicate()
	item.equipmentLevel = 1
	spendMaterials(recipe)
	equipmentInventoryArray.append(item)
	return true


func upgradeEquipment(item: Equipment) -> bool:
	if not equipmentInventoryArray.has(item) or item.costArray.is_empty() or not hasMaterials(item):
		return false
	spendMaterials(item)
	item.equipmentLevel += 1
	return true


func hireRecruit(recruit_id: StringName) -> bool:
	if not BAR_RECRUITS.has(recruit_id) or hiredRecruits.has(recruit_id):
		return false
	var recruit: Dictionary = BAR_RECRUITS[recruit_id]
	if barLevel < recruit.rank or not spendMaterial(recruit.material, recruit.cost):
		return false
	hiredRecruits.append(recruit_id)
	return true


func toggleCompanion(recruit_id: StringName) -> bool:
	if not hiredRecruits.has(recruit_id):
		return false
	if activeCompanions.has(recruit_id):
		activeCompanions.erase(recruit_id)
	elif activeCompanions.size() < PARTY_LIMIT:
		activeCompanions.append(recruit_id)
	else:
		return false
	return true


func upgradeBar() -> bool:
	if barLevel >= 2 or not spendMaterial(WOOD, BAR_UPGRADE_COST):
		return false
	barLevel = 2
	return true


func spendMaterial(material: MaterialItem, amount: int) -> bool:
	if materialCount(material) < amount:
		return false
	materialInventoryDictonary[material] -= amount
	return true


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

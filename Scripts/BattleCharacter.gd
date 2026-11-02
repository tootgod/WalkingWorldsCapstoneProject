class_name BattleCharacter
extends CharacterBody3D

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

@export var characterResource:CharacterResource:
	set(value):
		if value != null:
			characterResource = value
			displayName = characterResource.displayName
			battleClass = characterResource.battleClass
			passiveAbility = characterResource.passiveAbility
			moveList = characterResource.moveList
			currentLevel = characterResource.currentLevel
			
			currentHealth = characterResource.currentHealth
			currentMana = characterResource.currentMana
			
			defense = characterResource.defense
			maxHealth = characterResource.maxHealth
			maxMana = characterResource.maxMana
			willpower = characterResource.willpower
			strength = characterResource.strength
			intelligence = characterResource.intelligence
			speed = characterResource.speed
			luck = characterResource.luck
		

var displayName: String = "Character"
var battleClass: CharacterClass
var passiveAbility: PassiveAbility
var moveList: Array[Move]
var currentLevel:int = 1 

var currentHealth: int = 10
var currentMana:int = 10

#put variables for equipment here when that system is developed
#@export var equippedWeapon:Equipment = preload("res://Resources/Unequiped.tres")
#@export var equippedArmor:Equipment = preload("res://Resources/Unequiped.tres")
#@export var equippedAccessory:Equipment = preload("res://Resources/Unequiped.tres")

#@export_group("Battle Stats")
var defense: int = 10
var maxHealth: int = 10#HP amount
var maxMana: int = 10#MP amount
var willpower: int = 10#Magical Damage Reduction
var strength: int = 10#Physical Damage bonus
var intelligence: int = 10#Magical Damage Bonus
var speed: int = 10 #speed shortens time between attacks, with diminishing returns
var luck: int = 10#Critical Hit chance
 

const ATTACK_NUMBER = preload("res://Scenes/attack_number.tscn")
@export var isComputerControlled: bool = true
var wantsToAttack:bool = false

signal sendAttack(moveToUse:Move,user:BattleCharacter)



func _ready() -> void:
	$AttackTimer.wait_time = (.8- pow(1.01,-speed) * (1-5) + 5)
	$AttackTimer.start($AttackTimer.wait_time)
	#print($AttackTimer.wait_time)

func _physics_process(delta: float) -> void:
	if wantsToAttack:
		waitForAttackProcess()



func waitForAttackProcess():
	pass



func _on_attack_timer_timeout() -> void:
	wantsToAttack = true

##Default Behavior is to play basic attack animation, override to get different effects when attacking
func attackAnimation():
	$AnimationPlayer.play("attack Animation")

##Returns a random valid attack from characters movelist[br]
##Otherwise returns null if no valid attack found for character
func try_attack() -> Move:
	var moveToUse
	if !moveList.is_empty():
		moveToUse = moveList.pick_random()
		return moveToUse
	return null


func reciveAttack(move:Move,user:BattleCharacter):
	var damageToTake:int
	if move.mainAttackType == GlobalData.attackType.PHYSICAL:
		damageToTake = int(((2.8 * move.power *(user.strength/defense))/50) + 2)
	elif move.mainAttackType == GlobalData.attackType.MAGICAL:
		damageToTake = int(((2.8 * move.power *(user.intelligence/willpower))/50) + 2)
	
	if rng.randi_range(0,luck) > 50:
		damageToTake *= 2
	currentHealth -= damageToTake
	
	createDamageParticle(damageToTake)
	
	
	
func playDamageAnimation():
	pass
	
func createDamageParticle(number:int):
	var part := ATTACK_NUMBER.instantiate()
	part.updateNumber(number)
	add_sibling(part)
	part.position = position
	part.position.y += .8

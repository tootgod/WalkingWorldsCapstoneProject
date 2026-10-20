class_name BattleCharacter
extends CharacterBody3D

@export var displayName: String = "Character"
@export var battleClass: CharacterClass
@export var passiveAbility: PassiveAbility
@export var moveList: Array[Move]

@export var currentHealth: int = 10
@export var currentMana:int = 10

#put variables for equipment here when that system is developed
@export var equippedWeapon:Equipment
@export var equippedArmor:Equipment
@export var equippedAccessory:Equipment

@export_group("Battle Stats")
@export var defense: int = 10
@export var maxHealth: int = 10
@export var maxMana: int = 10
@export var willpower: int = 10
@export var strength: int = 10
@export var intelligence: int = 10
@export var speed: int = 10 #speed shortens time between attacks, with diminishing returns
@export var luck: int = 10

@export_group("Battle Stat Remainders")
@export var defenseRemainder: float
@export var healthRemainder: float
@export var manaRemainder: float
@export var willpowerRemainder: float
@export var strengthRemainder: float
@export var intelligenceRemainder: float
@export var speedRemainder: float
@export var luckRemainder: float

const ATTACK_NUMBER = preload("res://Scenes/attack_number.tscn")
@export var isComputerControlled: bool = true
var wantsToAttack:bool = false

signal sendAttack(moveToUse:Move,user:BattleCharacter)

func _ready() -> void:
	$AttackTimer.wait_time = (.8- pow(1.01,-speed) * (1-5) + 5)
	$AttackTimer.start()
	print($AttackTimer.wait_time)

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

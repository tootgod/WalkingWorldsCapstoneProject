class_name CharacterResource
extends Resource

@export var displayName: String = "Character"
@export var battleClass: CharacterClass
@export var passiveAbility: PassiveAbility
@export var moveList: Array[Move]
@export var currentLevel:int = 1 

@export var characterModel:String

@export var currentHealth: int = 10
@export var currentMana:int = 10

#put variables for equipment here when that system is developed
@export var equippedWeapon:Equipment = preload("res://Resources/Unequiped.tres")
@export var equippedArmor:Equipment = preload("res://Resources/Unequiped.tres")
@export var equippedAccessory:Equipment = preload("res://Resources/Unequiped.tres")

@export_group("Battle Stats")
@export var defense: int = 10:#Physical Damage Reduction
	get:
		return defense + equippedAccessory.bonusDefense + equippedArmor.bonusDefense + equippedWeapon.bonusDefense
	set(value):
		defense = value
@export var maxHealth: int = 10:#HP amount
	get:
		return maxHealth + equippedAccessory.bonusMaxHealth + equippedArmor.bonusMaxHealth + equippedWeapon.bonusMaxHealth
	set(value):
		maxHealth = value
@export var maxMana: int = 10:#MP amount
	get:
		return maxMana + equippedAccessory.bonusMaxMana + equippedArmor.bonusMaxMana + equippedWeapon.bonusMaxMana
	set(value):
		maxMana = value
@export var willpower: int = 10:#Magical Damage Reduction
	get:
		return willpower + equippedAccessory.bonusWillpower + equippedArmor.bonusWillpower + equippedWeapon.bonusWillpower
	set(value):
		willpower = value
@export var strength: int = 10:#Physical Damage bonus
	get():
		return strength + equippedAccessory.bonusStrength + equippedArmor.bonusStrength + equippedWeapon.bonusStrength
	set(value):
		strength = value
@export var intelligence: int = 10:#Magical Damage Bonus
	get:
		return intelligence + equippedAccessory.bonusIntelligence + equippedArmor.bonusIntelligence + equippedWeapon.bonusIntelligence
	set(value):
		intelligence = value
@export var speed: int = 10: #speed shortens time between attacks, with diminishing returns
	get:
		return speed + equippedAccessory.bonusSpeed + equippedArmor.bonusSpeed + equippedWeapon.bonusSpeed
	set(value):
		speed = value
@export var luck: int = 10:#Critical Hit chance
	get:
		return luck + equippedAccessory.bonusLuck + equippedArmor.bonusLuck + equippedWeapon.bonusLuck
	set(value):
		luck = value

@export_group("Battle Stat Remainders")
@export var defenseRemainder: float = 0.0
@export var healthRemainder: float = 0.0
@export var manaRemainder: float = 0.0
@export var willpowerRemainder: float = 0.0
@export var strengthRemainder: float = 0.0
@export var intelligenceRemainder: float = 0.0
@export var speedRemainder: float = 0.0
@export var luckRemainder: float = 0.0

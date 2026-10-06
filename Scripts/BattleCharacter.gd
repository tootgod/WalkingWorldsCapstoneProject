class_name BattleCharacter
extends Node3D

@export var displayName: String = "Character"
@export var battleClass: CharacterClass
@export var passiveAbility: PassiveAbility
@export var moveList: Array[Move]

@export var currentHealth: int = 10
@export var currentMana:int = 10

#put variables for equipment here when that system is developed

@export_group("Battle Stats")
@export var defense: int = 10
@export var maxHealth: int = 10
@export var willpower: int = 10
@export var strength: int = 10
@export var intelligence: int = 10
@export var speed: int = 10
@export var luck: int = 10

@export_group("Battle Stat Remainders")
@export var defenseRemainder: float
@export var healthRemainder: float
@export var willpowerRemainder: float
@export var strengthRemainder: float
@export var intelligenceRemainder: float
@export var speedRemainder: float
@export var luckRemainder: float

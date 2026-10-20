extends BattleCharacter


#General flow of combat for the Player:
#When the attack timer times out, character enters a waiting for action state and a menu pops up
#Player selects attack option from the menu then selects a target
#This scene sends out signal about the details about target and attack
#->
#Battle Scene recives info sends the attack to the target
#
#

signal tryToAttack(moveArray:Array[Move])


func reciveAttack(move:Move,user:BattleCharacter):
	super(move,user)
	
	$"character-female-d2/AnimationPlayer".play("fall")
	await $"character-female-d2/AnimationPlayer".animation_finished
	$"character-female-d2/AnimationPlayer".play("static")

func _on_attack_timer_timeout() -> void:
	super()
	tryToAttack.emit(moveList)

extends BattleCharacter


#intended flow of combat for enemy:
#Attack Timer times out, enemy plays "attack Coming" animation for 1 sec
#after 1 second, enemy choosed random party memeber to attack, and a valid move
#This scene sends out signal about the details about target and attack
#->
#Battle Scene recives info sends the attack to the target

	

func _on_attack_timer_timeout_enemy() -> void:
	$AttackDelay.start()

func _on_attack_delay_timeout() -> void:
	wantsToAttack = false
	sendAttack.emit(try_attack(),self)
	$AttackTimer.start()
	$"ModelPivot/character-skeleton2/AnimationPlayer".play("attack-melee-left")
	

func waitForAttackProcess():
	$"ModelPivot/character-skeleton2/AnimationPlayer".play("idle")
	

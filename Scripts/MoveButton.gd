extends TextureButton

signal sendAttack

var move : Move:
	set(newMove):
		move = newMove
		updateMove(move)


func updateMove(newMove:Move):
	$"Move Name".text = newMove.name
	$"MP Cost".text = "MP: " + str(newMove.manaCost)
	$MomentumGeneration.text = "MomG: " + str(newMove.momentumGeneration)
	$MomentumCost.text = "MomC: " + str(newMove.momentumCost)
	visible = true


func _on_pressed() -> void:
	sendAttack.emit(move)

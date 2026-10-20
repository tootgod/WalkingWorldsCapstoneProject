extends TextureButton

signal sendAttack

var move : Move:
	set(newMove):
		move = newMove
		updateMove(move)


func updateMove(newMove:Move):
	$"Move Name".text = newMove.name
	visible = true


func _on_pressed() -> void:
	sendAttack.emit(move)

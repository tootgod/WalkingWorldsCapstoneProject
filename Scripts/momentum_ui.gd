extends Control

func _ready() -> void:
	updateUI(GlobalManager.momentum)
	GlobalManager.momentumChanged.connect(updateUI)

func updateUI(mom:int):
	$Label.text = "Momentum: " + str(mom) + "/300"

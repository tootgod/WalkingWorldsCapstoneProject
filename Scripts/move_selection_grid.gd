extends GridContainer

func updateMoveGrid(moveArray:Array[Move]):
	var length:int
	if moveArray.size() > 8:
		length = moveArray.resize(8)
	
	for i in moveArray.size():
		get_node("Placeholder Move" + str(i)).move = moveArray[i]

func subscribeToAllMovesSendAttack(function:Callable):
	
	for i in range(0,7):
		get_node("Placeholder Move" + str(i)).sendAttack.connect(function)
		
	

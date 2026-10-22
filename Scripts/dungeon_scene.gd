extends Node3D

@export var goldenPathArray:Array[PackedScene]

func _ready() -> void:
	var pathPiece:DungeonPiece = $DungeonCenter
	goldenPathArray.shuffle()
	for i in range(0,len(goldenPathArray)):
		var nextPiece = goldenPathArray.pop_front().instantiate()
		add_child(nextPiece)
		#await get_tree().create_timer(0.1).timeout
		if nextPiece is DungeonPiece:
			pathPiece.goldenPathBuilder(nextPiece)
			pathPiece = nextPiece
			#$Camera3D.global_position.z = pathPiece.global_position.z

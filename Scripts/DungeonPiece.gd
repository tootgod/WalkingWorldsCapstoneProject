class_name DungeonPiece
extends Node3D
##Make sure to only use pieces that will fit. [br]
##Non Dungeon Pieces can be put in but are not expicity supported
@export var piecesList:Array[PackedScene]
const ERROR_PIECE = preload("res://Scenes/DungeonTiles/error_piece.tscn")

var pointsArray:Array[Marker3D]

func _ready() -> void:
	for child in get_children():
		if child is Marker3D:
			pointsArray.append(child)
		
	#placeAtAllNodes()
	
func placeAtAllNodes():
	if not piecesList.is_empty():
		for point in pointsArray:
			var piece:DungeonPiece = piecesList.pick_random().instantiate()
			var i := 1
			while !(piece is DungeonPiece):
				piece = piecesList.pick_random().instantiate()
				i+=1 
				if i>100:
					piece = ERROR_PIECE.instantiate()
					continue
			add_sibling.call_deferred(piece)
			piece.position = point.global_position
			piece.rotation = point.global_rotation
			
			pointsArray.erase(point)
			point.queue_free()
			

func goldenPathBuilder(piece:DungeonPiece):
	var point = pointsArray.pick_random()
	pointsArray.erase(point)
	
	
	piece.position = point.global_position
	piece.rotation = point.global_rotation
	
	point.queue_free()

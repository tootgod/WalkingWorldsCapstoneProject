extends Node3D

@export var goldenPathArray:Array[PackedScene]
const DUNGEON_BOSS_ROOM = preload("res://Scenes/DungeonTiles/dungeon_boss_room.tscn")
var goldenPathPieces:Array[DungeonPiece]= [] 

func _ready() -> void:
	print("newTry")
	var pathPiece:DungeonPiece = $DungeonCenter
	goldenPathPieces.push_back(pathPiece)
	goldenPathArray.shuffle()
	var test
	var dungeonSize:int = min(20,len(goldenPathArray))
	for i in range(0,dungeonSize):
		var nextPiece:DungeonPiece = goldenPathArray.pop_back().instantiate()
		nextPiece.visible = false
		add_child(nextPiece)
		nextPiece.overlapError.connect(resetScene)
	
		if nextPiece is DungeonPiece:
			test = pathPiece.goldenPathBuilder(nextPiece)
			while !test:
				resetScene()
				return
			pathPiece = nextPiece
			goldenPathPieces.push_back(pathPiece)
			#$Camera3D.global_position.z = pathPiece.global_position.z
			nextPiece.visible = true
			nextPiece.checkAllMarkers()
	var nextpiece = DUNGEON_BOSS_ROOM.instantiate()
	add_child(nextpiece)
	nextpiece.overlapError.connect(resetScene)
	goldenPathPieces.push_back(pathPiece)
	test = pathPiece.goldenPathBuilder(nextpiece)
	while !test:
		resetScene()
		return
	
	await get_tree().create_timer(0.1).timeout
	for p in goldenPathPieces:
		p.overlapError.disconnect(resetScene)
		p.checkAllMarkers()
	for p in goldenPathPieces:
		await p.placeSidePaths()
	
	for child in get_children():
		if child is DungeonPiece:
			child.checkAllOverlap(resetScene)
			child.connectAllonTouch(_on_touch_detector_component_area_touched)
			child.getAllNavChildrenToChildOf($NavigationRegion3D)
			child.deleteAllMarkerDeleters()
	$NavigationRegion3D.bake_navigation_mesh()
	print("dungeon Ready")
	$ColorRect.queue_free()

func _on_touch_detector_component_area_touched(event_position: Vector3) -> void:
	print(event_position)
	$PlayerControlledCharacter.set_movement_target(event_position)


func resetScene():
	#await get_tree().create_timer(3).timeout
	while true:
		if is_inside_tree() and get_tree():
			get_tree().reload_current_scene.call_deferred()
			return

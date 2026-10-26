class_name DungeonPiece
extends Node3D
##Make sure to only use pieces that will fit. [br]
##Non Dungeon Pieces can be put in but are not expicity supported
@export var piecesList:Array[PackedScene]

var pointsArray:Array[DungeonMarker]
@onready var marker_deleter: Area3D = $MarkerDeleter
@onready var side_path: Node3D = $SidePath

var sidePathFailed:bool = false
var currentPath:Array[DungeonPiece]=[]

var rng = RandomNumberGenerator.new()

signal overlapError
signal sidePathDone

func _ready() -> void:
	for child in get_children():
		if child is Marker3D:
			pointsArray.append(child)
	
func _process(delta: float) -> void:
	#checkAllMarkers()
	if marker_deleter != null:
		var overlap = $MarkerDeleter.get_overlapping_areas()
		for ol in overlap:
				if ol.get_parent() is DungeonPiece:
					overlapError.emit()

func placeSidePaths():
	#var newNode:Node3D = Node3D.new()
	
	if not piecesList.is_empty() and not pointsArray.is_empty():
		for point in pointsArray:
			currentPath = []
			await tryPlacePathAtPoint(point)
			await get_tree().create_timer(0.1).timeout
			var i := 0
			while sidePathFailed and i < 20:
				#print("newTRy")
				i+=1
				sidePathFailed = false
				for p in currentPath:
					if p!= null:
						p.queue_free.call_deferred()
				if point != null:
					await tryPlacePathAtPoint(point)
				await get_tree().create_timer(0.1).timeout
			if i ==20:
					#print("CriticalPathFail")
					break
			
			
			

func tryPlacePathAtPoint(point:Marker3D):
	var piece:DungeonPiece = piecesList.pick_random().instantiate()
	currentPath.append(piece)
	var i := 1
	while !(piece is DungeonPiece):
		piece = piecesList.pick_random().instantiate()
		i+=1 
		if i>100:
			return
	side_path.add_child(piece)
	piece.global_position = point.global_position
	piece.global_rotation = point.global_rotation
	if is_inside_tree() and get_tree():
		await get_tree().physics_frame
	if is_inside_tree() and get_tree():
		await get_tree().physics_frame
	if piece != null:
		for ol in piece.marker_deleter.get_overlapping_areas():
				if ol.get_parent() is DungeonPiece:
					sidePathFailed = true
		if piece.pointsArray.is_empty():
			sidePathDone.emit()
			return
		else:
			tryPlacePathAtPoint(piece.pointsArray.pick_random())

func choosePoint()->Marker3D:
	if pointsArray.is_empty():
		return null
	var point = pointsArray.pick_random()
	var i = 0
	while point == null:
		point = pointsArray.pick_random()
		i += 1
		if i>100:
			return null
	return point
func goldenPathBuilder(piece:DungeonPiece):
	var point: = choosePoint()
	var i = 0
	var test = attemptPlacePiece(piece,point)
	while !test:
		test = attemptPlacePiece(piece,point)
		i+=1
		point = choosePoint()
		if i > 1:
			print("Critcal Dungeon Placement Failure!!!!!")
			if overlapError!= null:
				overlapError.emit()
			return false
	#pointsArray.erase(point)
	#point.queue_free()
	checkAllMarkers()
	#piece.checkAllMarkers()
	return true

func attemptPlacePiece(piece:DungeonPiece,point:Marker3D) -> bool:
	if point == null:
		return false
	var oldPos = piece.position
	var oldRot = piece.rotation
	piece.position = point.global_position
	piece.rotation = global_rotation + point.rotation
	
	#await get_tree().physics_frame
	#this second await make is so it is almost 100% consistant, it just seem to be unessesary
	#await get_tree().physics_frame
	if piece.marker_deleter != null:
		var overlap = piece.marker_deleter.get_overlapping_areas()
		for ol in overlap:
			if ol.get_parent() is DungeonPiece:
				#print("Dungeon Overlap")
				piece.position = oldPos
				piece.rotation = oldRot
				return false
	return true

func checkAllMarkers():
	var ray = []
	for point in pointsArray:
		var temp := point.checkForOverlap()
		if temp != null:
			ray.append(temp)
			
	if !ray.is_empty():
		for point in ray:
			pointsArray.erase(point)
			point.queue_free.call()
	await get_tree().physics_frame
	
func connectAllonTouch(callable:Callable):
	$TouchBody/TouchDetectorComponent.area_touched.connect(callable)
	for child in side_path.get_children():
			if child is DungeonPiece:
				child.connectAllonTouch(callable)
				

func checkAllOverlap(signalNeeder:Callable):
	overlapError.connect(signalNeeder)
	for ol in marker_deleter.get_overlapping_areas():
			if ol.get_parent() is DungeonPiece:
				overlapError.emit()
	for child in side_path.get_children():
		if child is DungeonPiece:
			child.checkAllOverlap(signalNeeder)
		
func getAllNavChildrenToChildOf(node:NavigationRegion3D):
	for child in $NavigationRegion3D.get_children():
		child.reparent(node)
	for child in side_path.get_children():
		if child is DungeonPiece:
			child.getAllNavChildrenToChildOf(node)
			
func deleteAllMarkerDeleters():
	$MarkerDeleter.queue_free.call_deferred()
	for child in side_path.get_children():
		if child is DungeonPiece:
			child.deleteAllMarkerDeleters()
func _on_marker_deleter_area_entered(area: Area3D) -> void:
	if area.get_parent() is DungeonPiece:
		if overlapError !=null:
			overlapError.emit()

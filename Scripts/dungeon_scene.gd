extends Node3D
var dungeonArray:Array[DungeonGenerator]
var finalDungeon:DungeonGenerator
const DUNGEON_GENERATOR = preload("res://Scenes/dungeon_generator.tscn")
var dungeonChosen:bool = false


func _ready() -> void:
	for num in range(0,8):
		var dungeon: DungeonGenerator = DUNGEON_GENERATOR.instantiate()
		dungeonArray.append(dungeon)
		add_child(dungeon)
		dungeon.position.y = 10*num
		dungeon.generationCompleted.connect(finalizeDungeon)
		dungeon.generationFailed.connect(resetDungeon)
		

func resetDungeon(dungeon:DungeonGenerator):
	await get_tree().physics_frame
	if dungeonArray.has(dungeon):
		#print(dungeonArray)
		var i := 0
		var yPos:float = dungeon.position.y
		for child in dungeonArray:
			if child != null and child.name == dungeon.name:
				#print(i)
				child.queue_free.call_deferred()
				break
			i+=1
		var d: DungeonGenerator = DUNGEON_GENERATOR.instantiate()
		
		dungeonArray[i-1] = d
		#print(dungeonArray)
		add_child(d)
		d.position.y = yPos
		d.generationCompleted.connect(finalizeDungeon)
		d.generationFailed.connect(resetDungeon)
	else:
		dungeon.queue_free.call_deferred()
func finalizeDungeon(dungeon:DungeonGenerator):
	if dungeonChosen == false:
		dungeonChosen = true
		finalDungeon = dungeon
		#finalDungeon.position.y = 0
		for child in dungeonArray:
			if child != null and !(child.name == finalDungeon.name):
				child.queue_free.call_deferred()
	else:
		if dungeon != null:
			dungeon.queue_free.call_deferred()


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://Scenes/main_town.tscn")

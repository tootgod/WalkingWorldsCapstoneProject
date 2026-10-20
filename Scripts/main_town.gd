extends Node3D
const TOWN_MENU = preload("res://Scenes/town_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_town_hall_town_hall_pressed(event_position:Vector3) -> void:
		$"UI".add_child(TOWN_MENU.instantiate())
		$PlayerControlledCharacter.set_movement_target(event_position)


func _on_touch_detector_component_area_touched(event_position: Vector3) -> void:
	$PlayerControlledCharacter.set_movement_target(event_position)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == $PlayerControlledCharacter:
		
		get_tree().change_scene_to_file.call_deferred("res://Scenes/BattleScene.tscn")


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		$PlayerControlledCharacter.set_movement_target($Area3D/CollisionShape3D.global_position)

extends Node3D
var gate_menu_instance: Node
const TOWN_MENU = preload("res://Scenes/town_menu.tscn")
const GATE_MENU = preload("uid://d3v327pw2ktcn")
const BATTLE_SCENE = preload("uid://bpaixwb52t8da")


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
		GlobalManager.loadBattle(BATTLE_SCENE)
		#get_tree().change_scene_to_file.call_deferred("res://Scenes/BattleScene.tscn")


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		$PlayerControlledCharacter.set_movement_target($Area3D/CollisionShape3D.global_position)


func _on_gate_touch_area_input_event(
	camera: Node,
	event: InputEvent,
	event_position: Vector3,
	normal: Vector3,
	shape_idx: int
) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			return
	elif event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
			return
	else:
		return

	if is_instance_valid(gate_menu_instance):
		return

	gate_menu_instance = GATE_MENU.instantiate()
	$UI.add_child(gate_menu_instance)


func _on_area_3d_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		$PlayerControlledCharacter.set_movement_target($Area3D2/CollisionShape3D.global_position)

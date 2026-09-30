extends Node3D
const TOWN_MENU = preload("uid://d3x263mywo5ij")

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

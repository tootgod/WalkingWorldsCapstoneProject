extends Node3D
signal town_hall_pressed(event_position:Vector3)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			town_hall_pressed.emit(event_position)

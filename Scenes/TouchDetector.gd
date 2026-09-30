class_name TouchDetectorComponent
extends Node

signal area_touched(event_position:Vector3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is CollisionObject3D:
		get_parent().input_event.connect(_on_input_event)
	else:
		print("Parent must be a CollsionObject3d")
		queue_free()

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("hi")
	if event is InputEventScreenTouch:
		if !event.pressed:
			area_touched.emit(event_position)

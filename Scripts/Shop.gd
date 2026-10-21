# shop building
extends Node3D
signal shop_pressed(event_position:Vector3)

# building color
@export var tint: Color = Color(1.0, 0.85, 0.7)


# color the building when it loads
func _ready() -> void:
	_apply_tint($Model)


# changes the color of every piece
func _apply_tint(node: Node) -> void:
	if node is MeshInstance3D and node.mesh:
		for i in node.mesh.get_surface_count():
			var material = node.mesh.surface_get_material(i)
			if material is BaseMaterial3D:
				material = material.duplicate()
				material.albedo_color = material.albedo_color * tint
				node.set_surface_override_material(i, material)
	for child in node.get_children():
		_apply_tint(child)


# tapping the shop
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			shop_pressed.emit(event_position)

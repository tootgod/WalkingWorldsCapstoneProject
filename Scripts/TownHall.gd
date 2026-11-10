extends Node3D
signal town_hall_pressed(event_position:Vector3)

@export var wall_tint: Color = Color.WHITE


func _ready() -> void:
	if wall_tint == Color.WHITE:
		return

	var tinted_textures: Dictionary[Texture2D, Texture2D] = {}
	for mesh_instance: MeshInstance3D in $Model.find_children("*", "MeshInstance3D", true, false):
		if mesh_instance.name == &"door":
			continue
		for surface in range(mesh_instance.mesh.get_surface_count()):
			var original := mesh_instance.get_active_material(surface) as BaseMaterial3D
			if original == null or original.albedo_texture == null:
				continue
			var texture := original.albedo_texture
			if not tinted_textures.has(texture):
				tinted_textures[texture] = recolor_stone(texture)
			var tinted := original.duplicate() as BaseMaterial3D
			tinted.albedo_texture = tinted_textures[texture]
			mesh_instance.set_surface_override_material(surface, tinted)


func recolor_stone(texture: Texture2D) -> Texture2D:
	var image := texture.get_image().duplicate() as Image
	if image.is_compressed() and image.decompress() != OK:
		return texture

	# The model's shared palette uses blue-gray for stone and warm colors for wood.
	var had_mipmaps := image.has_mipmaps()
	image.clear_mipmaps()
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel := image.get_pixel(x, y)
			if pixel.b > pixel.r:
				var stone := wall_tint * pixel.get_luminance()
				stone.a = pixel.a
				image.set_pixel(x, y, stone)
	if had_mipmaps:
		image.generate_mipmaps()
	return ImageTexture.create_from_image(image)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		if !event.pressed:
			town_hall_pressed.emit(event_position)

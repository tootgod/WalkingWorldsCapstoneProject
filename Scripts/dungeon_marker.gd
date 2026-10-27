class_name DungeonMarker
extends Marker3D

func _ready() -> void:
	if $Area3D.has_overlapping_areas():
		pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	pass

func checkForOverlap()->Marker3D:
	var overlap = $Area3D.get_overlapping_areas()
	for ol in overlap:
			if ol.get_parent() is DungeonPiece:
				return self
	return null

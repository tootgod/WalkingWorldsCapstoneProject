extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.get_parent() is Marker3D:
		area.get_parent().call_deferred("queue_free")

class_name DetectionRaycast
extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_colliding():
		print("coliding")
		var collider = get_collider()
		if collider is Area3D:
			print("hit :",collider.name)
	#else:
		##queue_free()
		#print("no area found")
		

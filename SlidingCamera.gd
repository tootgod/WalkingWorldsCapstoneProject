class_name TownCamera
extends Camera3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 0.876


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		position.x += event.screen_velocity.x/10000
		position.x = clampf(position.x,-5.84,6.324)
		
		rotate_x(-event.screen_velocity.y/700000)
		rotation_degrees.x = clampf(rotation_degrees.x,-55,-35)
		

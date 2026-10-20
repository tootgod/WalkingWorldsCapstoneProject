
extends RigidBody3D

var forceArray:Array[Vector3]= [Vector3.RIGHT,Vector3.LEFT]

func _ready() -> void:
	apply_force((forceArray.pick_random() + Vector3.UP)* 100)


func _on_timer_timeout() -> void:
	queue_free()

func updateNumber(number:int):
	$Sprite3D.text = str(number)

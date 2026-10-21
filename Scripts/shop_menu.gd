# shop popup
extends Control

# inside of the shop
const SHOP_INTERIOR = preload("res://Scenes/shop_interior.tscn")


# enter button
func _on_enter_button_pressed() -> void:
	pass
	#don't change the scene to a new one, keep the town scene running behind the shop
	#get_parent().add_child(SHOP_INTERIOR.instantiate())
	#queue_free()


# close button
func _on_close_button_pressed() -> void:
	queue_free()

# inside the shop
extends Control

# background picture
const BACKGROUND_PATH := "res://Assets/Backgrounds/shop_interior.jpg"


# load the background picture
func _ready() -> void:
	if ResourceLoader.exists(BACKGROUND_PATH):
		$Background.texture = load(BACKGROUND_PATH)


# exit button
func _on_exit_button_pressed() -> void:
	queue_free()

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	queue_free()


# --- Logging out ---
# Runs when the player taps "Log Out": signs them out of their account
# (deletes the saved login so the game won't auto-log them in) and
# sends them back to the welcome screen.
func _on_log_out_button_pressed() -> void:
	$"Log Out Button".disabled = true  # stop double taps while waiting for the server
	await Auth.sign_out()
	get_tree().change_scene_to_file("res://welcome.tscn")

extends Control

@export var walking_scene: PackedScene
@export var walk_button: Button


func _ready() -> void:
	if walk_button == null:
		return

	if not walk_button.pressed.is_connected(_on_go_on_walk_button_pressed):
		walk_button.pressed.connect(_on_go_on_walk_button_pressed)


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


func _on_dungeon_button_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(
		"res://Scenes/dungeon_scene.tscn"
	)


func _on_go_on_walk_button_pressed() -> void:
	print("걷기 버튼 실행됨")

	if walking_scene == null:
		push_error("Walking Scene에 walking_mode.tscn을 연결해주세요.")
		return

	get_tree().change_scene_to_packed.call_deferred(walking_scene)

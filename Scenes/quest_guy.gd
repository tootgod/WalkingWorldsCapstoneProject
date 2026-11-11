extends Area3D

@export var quest: Array[Quest] = []

@export var label_3d: Label3D
@export var dialogue_panel: PanelContainer
@export var dialogue_text: Label
@export var next_button: Button
@export var quest_panel: PanelContainer
@export var close_button: Button

var has_talked: bool = false


func _ready() -> void:
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_text.add_theme_font_size_override("font_size", 24)

	label_3d.hide()
	dialogue_panel.hide()
	quest_panel.hide()

	if not body_entered.is_connected(_on_area_3d_body_entered):
		body_entered.connect(_on_area_3d_body_entered)

	if not body_exited.is_connected(_on_area_3d_body_exited):
		body_exited.connect(_on_area_3d_body_exited)

	if not next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.connect(_on_next_pressed)

	if close_button:
		if not close_button.pressed.is_connected(_on_close_pressed):
			close_button.pressed.connect(_on_close_pressed)

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Inside the NPC: ", body.name)

	if not body.is_in_group("player"):
		print("Not a player group")
		return

	print("Check player")

	if has_talked:
		open_quest_page()
	else:
		dialogue_text.text = "In order to be safe, we need resource. You can go out of castles to find out matrials."
		next_button.text = "Next"
		dialogue_panel.show()
		print("Convsersation is on")


func _on_next_pressed() -> void:
	has_talked = true
	dialogue_panel.hide()
	open_quest_page()


func open_quest_page() -> void:
	quest_panel.show()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	dialogue_panel.hide()
	quest_panel.hide()
	
func _on_close_pressed() -> void:
	dialogue_panel.hide()
	quest_panel.hide()

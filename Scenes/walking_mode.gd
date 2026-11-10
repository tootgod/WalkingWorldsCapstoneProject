extends Node3D

@export var distance_label: Label
@export var steps_label: Label
@export var back_button: Button
@export var reward_anchor: Node3D

var last_reward_total: int = -1


func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

	HealthSteps.steps_updated.connect(_on_steps_updated)
	_on_steps_updated()


func _on_steps_updated() -> void:
	_update_walk_ui()

	var today := Time.get_date_string_from_system()

	if not HealthSteps.step_data_ready \
			or HealthSteps.last_step_date != today:
		return

	var current_total: int = HealthSteps.total_steps

	if last_reward_total < 0:
		last_reward_total = current_total
		return

	var new_steps: int = maxi(current_total - last_reward_total, 0)

	if new_steps == 0:
		return

	var gained: Dictionary = QuestRewards.give_walking_rewards(new_steps)
	last_reward_total = current_total

	if not gained.is_empty():
		_show_reward_popup(gained)


func _update_walk_ui() -> void:
	if not steps_label or not distance_label:
		return

	var today := Time.get_date_string_from_system()

	if not HealthSteps.step_data_ready \
			or HealthSteps.last_step_date != today:
		steps_label.text = "Getting today's steps..."
		distance_label.text = "Estimated distance: —"
		return

	var today_steps: int = maxi(HealthSteps.last_step_count, 0)
	var miles: float = float(today_steps) / 2000.0

	steps_label.text = "Today's steps: %d" % today_steps
	distance_label.text = "Estimated distance: %.2f miles" % miles


func _show_reward_popup(gained: Dictionary) -> void:
	if not is_instance_valid(reward_anchor):
		push_warning("Connect Reward Anchor in the Inspector.")
		return

	var lines := PackedStringArray()

	for path in gained:
		var item_name := str(path).get_file().get_basename()
		lines.append("%s +%d" % [item_name, int(gained[path])])

	var popup := Label3D.new()
	popup.text = "\n".join(lines)
	popup.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	popup.no_depth_test = true
	popup.font_size = 48
	popup.pixel_size = 0.008
	popup.modulate = Color(1.0, 0.9, 0.3)
	popup.outline_modulate = Color.BLACK
	popup.outline_size = 8

	reward_anchor.add_child(popup)
	popup.position = Vector3.ZERO
	
	var tween := popup.create_tween()
	tween.tween_property(
		popup,
		"position",
		popup.position + Vector3.UP * 0.8,
		2.0
	)
	tween.parallel().tween_property(
		popup, "modulate:a", 0.0, 2.0
	)
	tween.parallel().tween_property(
		popup, "outline_modulate:a", 0.0, 2.0
	)
	tween.finished.connect(popup.queue_free)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(
		"res://Scenes/main_town.tscn"
	)

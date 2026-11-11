extends Node
class_name WalkingQuestManager

@export var quests: Array[Quest] = []
@export var quest_list: VBoxContainer

const SAVE_PATH := "user://walking_quests.cfg"

var states: Dictionary = {}
var rows: Dictionary = {}
var steps_ready: bool = false
var last_total: int = -1
var quest_day: String = ""
var daily_quests: Array[Quest] = []


func _ready() -> void:
	load_states()
	_refresh_daily_quests()

	HealthSteps.steps_updated.connect(_sync_steps)
	_sync_steps()


func build_list() -> void:
	if quest_list == null:
		push_error("Quest List needs VBoxContainer connection.")
		return

	quest_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for child in quest_list.get_children():
		quest_list.remove_child(child)
		child.queue_free()

	rows.clear()

	for quest in daily_quests:
		if quest == null:
			continue

		if quest.id.is_empty() or rows.has(quest.id):
			push_error("Rather Quest Ip is empty or there is same name file: " + quest.id)
			continue

		if not states.has(quest.id):
			states[quest.id] = {
				"accepted": false,
				"progress": 0
			}

		var box := VBoxContainer.new()
		quest_list.add_child(box)

		var label := Label.new()
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(label)

		var button := Button.new()
		box.add_child(button)
		button.pressed.connect(accept_quest.bind(quest.id))

		var separator := HSeparator.new()
		box.add_child(separator)

		rows[quest.id] = {
			"label": label,
			"button": button
		}

	update_ui()


func accept_quest(quest_id: String) -> void:
	if quest_day != Time.get_date_string_from_system():
		_sync_steps()
		return
		
	print("[Quest] Button pressed: ", quest_id)

	if not states.has(quest_id):
		push_warning("[Quest] Quest state missing: " + quest_id)
		return

	if not steps_ready or HealthSteps.last_step_date != Time.get_date_string_from_system():
		push_warning("[Quest] Today's step data is not ready.")
		return
	
	_sync_steps()

	var state: Dictionary = states[quest_id]

	if not state["accepted"]:
		state["accepted"] = true
		_sync_steps()
		return

	for quest in daily_quests:
		if quest == null or quest.id != quest_id:
			continue

		if int(state["progress"]) < quest.target_steps:
			return

		var reward_id: String = _quest_reward_id(quest)
		if QuestRewards.claimed_quests.has(reward_id):
			update_ui()
			return

		var reward_amount: int = maxi(1, int(quest.target_steps / 10.0))
		var gained: Dictionary = QuestRewards.give_walking_rewards(
			0, reward_id, quest.reward_materials
		)

		if gained.is_empty():
			push_warning("[Quest] No materials returned. Check the reward save log.")
			return

		print("[Quest] Materials received: ", gained)
		update_ui()
		return


func add_steps(amount: int) -> void:
	steps_ready = true

	for quest in daily_quests:
		if quest == null or not rows.has(quest.id):
			continue

		var state: Dictionary = states[quest.id]

		if not state["accepted"]:
			continue

		state["progress"] = mini(
			int(state["progress"]) + maxi(amount, 0),
			quest.target_steps
		)

	save_states()
	update_ui()


func update_ui() -> void:
	for quest in daily_quests:
		if quest == null or not rows.has(quest.id):
			continue

		var state: Dictionary = states[quest.id]
		var label: Label = rows[quest.id]["label"]
		var button: Button = rows[quest.id]["button"]

		var accepted: bool = state["accepted"]
		var progress: int = state["progress"]
		var completed := accepted and progress >= quest.target_steps

		label.text = "%s\n%s\n%d / %d steps" % [
			quest.name,
			quest.description,
			progress,
			quest.target_steps
		]

		button.disabled = not steps_ready or (accepted and not completed)		
		var claimed: bool = QuestRewards.claimed_quests.has(_quest_reward_id(quest))
		
		if claimed:
			button.text = "Quest Complete"
			button.disabled = true
			label.text += "\nReward claimed"

			var receipt: Variant = QuestRewards.claimed_quests[_quest_reward_id(quest)]
			if receipt is Dictionary:
				for path in receipt:
					var item_name := str(path).get_file().get_basename()
					label.text += "\n%s +%d" % [item_name, int(receipt[path])]
		elif completed:
			button.text = "Complete!"
			button.disabled = not steps_ready
		elif accepted:
			button.text = "Processing"
		elif not steps_ready:
			button.text = "Conencting walking data"
		else:
			button.text = "Accept"


func save_states() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("quests", "states", states)
	cfg.set_value("quests", "last_total", last_total)
	cfg.set_value("quests", "day", quest_day)

	var error := cfg.save(SAVE_PATH)
	if error != OK:
		push_error("Quest Save fail: %s" % error)


func load_states() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	
	quest_day = str(cfg.get_value("quests", "day", ""))
	var saved_states = cfg.get_value("quests", "states", {})
	if saved_states is Dictionary:
		states = saved_states
		last_total = int(cfg.get_value("quests", "last_total", HealthSteps.total_steps))

func _sync_steps() -> void:
	_refresh_daily_quests()
	
	steps_ready = (
		HealthSteps.step_data_ready
		and HealthSteps.last_step_date == Time.get_date_string_from_system()
	)

	if not steps_ready:
		update_ui()
		return

	var today_steps: int = maxi(HealthSteps.last_step_count, 0)

	for quest in daily_quests:
		if quest == null or not states.has(quest.id):
			continue

		var state: Dictionary = states[quest.id]

		if not state["accepted"]:
			continue

		state["progress"] = mini(today_steps, quest.target_steps)

	save_states()
	update_ui()
	
func _quest_reward_id(quest: Quest) -> String:
	return "daily_quest:%s:%s" % [
		quest.id,
		Time.get_date_string_from_system()]
	
func _refresh_daily_quests() -> void:
	var today := Time.get_date_string_from_system()

	if quest_day == today and not daily_quests.is_empty():
		return

	if quest_day != today:
		quest_day = today
		states.clear()

	var candidates: Dictionary = {}
	for quest in quests:
		if quest == null or quest.id.is_empty():
			continue
		if candidates.has(quest.id):
			push_warning("Duplicate quest ID: " + quest.id)
			continue
		candidates[quest.id] = quest

	var ids: Array = candidates.keys()
	ids.sort()

	var rng := RandomNumberGenerator.new()
	rng.seed = today.hash()

	daily_quests.clear()
	for i in range(mini(3, ids.size())):
		var index := rng.randi_range(0, ids.size() - 1)
		var quest_id: String = ids.pop_at(index)
		daily_quests.append(candidates[quest_id])

	build_list()
	save_states()

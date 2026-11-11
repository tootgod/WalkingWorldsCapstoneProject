extends Node

const SAVE_PATH := "user://quest_rewards.cfg"

var walk_progress: int = 0
var material_counts: Dictionary = {}

var claimed_quests: Dictionary = {}


func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		material_counts = cfg.get_value("rewards", "materials", {})
		claimed_quests = cfg.get_value("rewards", "claimed", {})
		walk_progress = int(cfg.get_value("rewards", "walk_progress", 0))


func give_walking_rewards(new_steps: int) -> Dictionary:
	if new_steps <= 0:
		return {}

	var accumulated := walk_progress + new_steps
	var reward_count := int(accumulated / 100)
	var remainder := accumulated % 100

	var new_counts := material_counts.duplicate()
	var gained: Dictionary = {}

	if reward_count > 0:
		var generator := MaterialItemGenerator.new()

		for i in range(reward_count):
			var item: MaterialItem = generator.getRandomMaterial()
			var item_path := item.resource_path

			new_counts[item_path] = int(new_counts.get(item_path, 0)) + 1
			gained[item_path] = int(gained.get(item_path, 0)) + 1

		generator.free()

	var cfg := ConfigFile.new()
	cfg.set_value("rewards", "materials", new_counts)
	cfg.set_value("rewards", "claimed", claimed_quests)
	cfg.set_value("rewards", "walk_progress", remainder)

	if cfg.save(SAVE_PATH) != OK:
		push_error("Walking reward save failed")
		return {}

	material_counts = new_counts
	walk_progress = remainder

	for item_path in gained:
		print("Walking reward: ", str(item_path).get_file(),
			" +", gained[item_path],
			" / total: ", material_counts[item_path])

	return gained

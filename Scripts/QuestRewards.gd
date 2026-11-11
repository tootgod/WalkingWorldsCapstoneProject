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

	print("Saved walking materials: ", material_counts)


func give_walking_rewards(
	new_steps: int,
	quest_reward_id: String = "",
	quest_reward_amount: int = 1
) -> Dictionary:
	if new_steps <= 0 and quest_reward_id.is_empty():
		return {}

	var new_claims: Dictionary = claimed_quests.duplicate()
	var accumulated: int = walk_progress + maxi(new_steps, 0)
	var reward_count: int = int(accumulated / 100.0)
	var remainder: int = accumulated % 100

	if not quest_reward_id.is_empty():
		if quest_reward_amount <= 0 or new_claims.has(quest_reward_id):
			return {}

		reward_count += quest_reward_amount

	var new_counts: Dictionary = material_counts.duplicate()
	var gained: Dictionary = {}

	if reward_count > 0:
		var generator := MaterialItemGenerator.new()

		for i in range(reward_count):
			var item: MaterialItem = generator.getRandomMaterial()
			var item_path: String = item.resource_path

			new_counts[item_path] = int(new_counts.get(item_path, 0)) + 1
			gained[item_path] = int(gained.get(item_path, 0)) + 1

		generator.free()
	
	if not quest_reward_id.is_empty():
		new_claims[quest_reward_id] = gained

	var cfg := ConfigFile.new()
	cfg.set_value("rewards", "materials", new_counts)
	cfg.set_value("rewards", "claimed", new_claims)
	cfg.set_value("rewards", "walk_progress", remainder)

	if cfg.save(SAVE_PATH) != OK:
		push_error("Reward save failed")
		return {}

	material_counts = new_counts
	claimed_quests = new_claims
	walk_progress = remainder

	for item_path in gained:
		print("Reward: ", str(item_path).get_file(),
			" +", gained[item_path],
			" / total: ", material_counts[item_path])
			
	if not quest_reward_id.is_empty() and not gained.is_empty():
		print("[Quest] Saved material totals: ", material_counts)

	return gained

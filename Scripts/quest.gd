extends Resource
class_name Quest

@export_category("Identification")
@export var id: String

@export_category("Description")
@export var name: String
@export_multiline var description: String
@export var breif_description: String

@export_category("Walking")
@export_range(1, 1000000) var target_steps: int = 2000

@export_category("Reward")
@export_range(1, 100) var reward_count: int = 1

@export var reward_materials: int = 100

extends Control

const MATERIAL_NAMES = {"IronWood": "Iron Wood"}

var creating := true

@onready var recipes := $"Recipe Scroll/Recipes"


func _ready() -> void:
	resized.connect(update_recipe_columns)


func update_recipe_columns() -> void:
	var has_cards := creating or not GlobalManager.equipmentInventoryArray.is_empty()
	recipes.columns = 2 if size.x >= 520.0 and has_cards else 1


func refresh_cards() -> void:
	update_recipe_columns()
	for card in recipes.get_children():
		recipes.remove_child(card)
		card.queue_free()

	if creating:
		for recipe in GlobalManager.CRAFTABLE_EQUIPMENT:
			add_recipe_card(recipe)
	elif GlobalManager.equipmentInventoryArray.is_empty():
		var empty := Label.new()
		empty.text = "Craft equipment first to upgrade it."
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		recipes.add_child(empty)
	else:
		for item in GlobalManager.equipmentInventoryArray:
			add_recipe_card(item)


func add_recipe_card(equipment: Equipment) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var background := StyleBoxFlat.new()
	background.bg_color = Color(0, 0, 0, 0.35)
	background.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", background)
	recipes.add_child(panel)

	var content := VBoxContainer.new()
	panel.add_child(content)
	var heading := Label.new()
	heading.text = equipment.itemName
	if not creating:
		heading.text += "  Lv %d → %d" % [equipment.equipmentLevel, equipment.equipmentLevel + 1]
	content.add_child(heading)

	var details := HBoxContainer.new()
	details.add_theme_constant_override("separation", 10)
	content.add_child(details)
	var icon := TextureRect.new()
	icon.texture = equipment.sprite
	icon.custom_minimum_size = Vector2(70, 70)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	details.add_child(icon)

	var costs := Label.new()
	costs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	costs.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var lines := PackedStringArray()
	if creating:
		lines.append("Requires Lv %d" % equipment.weaponRank)
	for cost in equipment.costArray:
		var material_name := cost.material.itemName
		if material_name.is_empty():
			var filename := cost.material.resource_path.get_file().get_basename()
			material_name = MATERIAL_NAMES.get(filename, filename)
		lines.append("%s ×%d (%d owned)" % [material_name, cost.amount, GlobalManager.materialCount(cost.material)])
	costs.text = "\n".join(lines)
	details.add_child(costs)

	var action := Button.new()
	action.custom_minimum_size = Vector2(112, 44)
	action.text = "Craft" if creating else "Upgrade"
	if creating and GlobalManager.playerLevel < equipment.weaponRank:
		action.text = "Requires level %d" % equipment.weaponRank
		action.disabled = true
	elif not GlobalManager.hasMaterials(equipment):
		action.text = "Not enough materials"
		action.disabled = true
	action.pressed.connect(apply_equipment_action.bind(equipment))
	content.add_child(action)


func apply_equipment_action(equipment: Equipment) -> void:
	var success: bool
	if creating:
		success = GlobalManager.craftEquipment(equipment)
		$Status.text = "Crafted %s." % equipment.itemName if success else "Crafting requirements not met."
	else:
		success = GlobalManager.upgradeEquipment(equipment)
		$Status.text = "Upgraded %s to Lv %d." % [equipment.itemName, equipment.equipmentLevel] if success else "Upgrade requirements not met."
	refresh_cards()


func _on_create_button_pressed() -> void:
	show_equipment_layout(true)


func _on_upgrade_button_pressed() -> void:
	show_equipment_layout(false)


func show_equipment_layout(is_creating: bool) -> void:
	creating = is_creating
	$Title.text = "What to Create?" if creating else "What to Upgrade?"
	$"Craftable Items".text = "Craftable Items" if creating else "Inventory Items"
	$"Welcome Actions".hide()
	$Greeting.hide()
	$"Craftable Items".show()
	$"Recipe Scroll".show()
	$"Recipe Scroll".scroll_vertical = 0
	$Status.text = "Player Lv %d" % GlobalManager.playerLevel if creating else ""
	$Status.show()
	refresh_cards()
	$"Back Button".show()
	$"Back Button".grab_focus()


func _on_back_button_pressed() -> void:
	$Title.text = "Smithy"
	$"Craftable Items".hide()
	$"Recipe Scroll".hide()
	$Status.hide()
	$"Back Button".hide()
	$"Welcome Actions".show()
	$Greeting.show()
	$"Welcome Actions/Buttons/Create Button".grab_focus()


func _on_close_button_pressed() -> void:
	queue_free()

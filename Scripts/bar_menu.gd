extends Control

@onready var roster := $Content/Scroll/Roster
@onready var upgrade_button := $Content/Upgrade
@onready var status := $Content/Status


func _ready() -> void:
	resized.connect(update_roster_columns)
	update_roster_columns()
	refresh_menu()


func update_roster_columns() -> void:
	roster.columns = 2 if size.x >= 520.0 else 1


func refresh_menu() -> void:
	$Content/Title.text = "Bar • Level %d" % GlobalManager.barLevel
	var names := PackedStringArray()
	for id in GlobalManager.activeCompanions:
		names.append(GlobalManager.BAR_RECRUITS[id].name)
	var party := "None selected" if names.is_empty() else ", ".join(names)
	$Content/Party.text = "Companions %d/%d\n%s" % [names.size(), GlobalManager.PARTY_LIMIT, party]

	var wood := GlobalManager.materialCount(GlobalManager.WOOD)
	var at_max := GlobalManager.barLevel >= 2
	upgrade_button.text = "Bar fully upgraded" if at_max else "Upgrade • %d Wood (%d owned)" % [GlobalManager.BAR_UPGRADE_COST, wood]
	upgrade_button.disabled = at_max or wood < GlobalManager.BAR_UPGRADE_COST

	for card in roster.get_children():
		roster.remove_child(card)
		card.queue_free()
	for id: StringName in GlobalManager.BAR_RECRUITS:
		var recruit: Dictionary = GlobalManager.BAR_RECRUITS[id]
		if recruit.rank <= GlobalManager.barLevel:
			add_recruit_card(id, recruit)


func add_recruit_card(id: StringName, recruit: Dictionary) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var background := StyleBoxFlat.new()
	background.bg_color = Color(0, 0, 0, 0.35)
	background.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", background)
	roster.add_child(panel)

	var content := VBoxContainer.new()
	panel.add_child(content)
	var hired := GlobalManager.hiredRecruits.has(id)
	var in_party := GlobalManager.activeCompanions.has(id)
	var info := Label.new()
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var passive: PassiveAbility = recruit.passive
	var passive_name := passive.name if passive != null else "None listed"
	info.text = "%s • Rank %d\nPassive: %s" % [recruit.name, recruit.rank, passive_name]
	content.add_child(info)

	var button := Button.new()
	button.custom_minimum_size = Vector2(112, 44)
	button.add_theme_font_size_override("font_size", 14)
	content.add_child(button)
	if hired:
		button.text = "Remove from Party" if in_party else "Add to Party"
		if not in_party and GlobalManager.activeCompanions.size() >= GlobalManager.PARTY_LIMIT:
			button.text = "Party Full"
			button.disabled = true
		button.pressed.connect(_on_party_pressed.bind(id))
	else:
		var material: MaterialItem = recruit.material
		var owned := GlobalManager.materialCount(material)
		var material_name := material.resource_path.get_file().get_basename().capitalize()
		button.text = "Hire • %d %s (%d owned)" % [recruit.cost, material_name, owned]
		button.disabled = owned < recruit.cost
		button.pressed.connect(_on_hire_pressed.bind(id))


func _on_hire_pressed(id: StringName) -> void:
	if GlobalManager.hireRecruit(id):
		status.text = "Hired %s." % GlobalManager.BAR_RECRUITS[id].name
	refresh_menu()


func _on_party_pressed(id: StringName) -> void:
	if GlobalManager.toggleCompanion(id):
		status.text = "Party updated."
	refresh_menu()


func _on_upgrade_pressed() -> void:
	if GlobalManager.upgradeBar():
		status.text = "Mage is now available to hire."
	refresh_menu()


func _on_close_pressed() -> void:
	queue_free()

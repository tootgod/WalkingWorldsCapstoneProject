extends Control

var health
var output: Label
var busy := false

func _ready():
	var box := VBoxContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 12
	box.offset_top = 30
	box.offset_right = -12
	box.offset_bottom = -20
	add_child(box)
	var title := Label.new()
	title.text = "Health Connect check"
	box.add_child(title)
	output = Label.new()
	output.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(output)
	var button := Button.new()
	button.text = "Connect / Refresh steps"
	button.pressed.connect(_check)
	box.add_child(button)
	if OS.get_name() != "Android":
		output.text = "Run this scene in an Android export. Desktop cannot load this Android plugin."
		button.disabled = true
		return
	if not Engine.has_singleton("HealthConnect"):
		output.text = "FAIL: HealthConnect plugin not loaded. Check Gradle Build and Android manifest registration."
		button.disabled = true
		return
	health = Engine.get_singleton("HealthConnect")
	output.text = "PASS: HealthConnect plugin loaded. Tap Connect."

func _check():
	if busy or health == null:
		return
	busy = true
	output.text = "Plugin loaded. Checking permissions..."
	health.updatePermissionStatus()
	await get_tree().create_timer(1.0).timeout
	if not health.hasStepPermission():
		if not health.isPermissionLauncherReady():
			output.text = "FAIL: Android permission launcher is not ready."
			busy = false
			return
		health.requestStepPermission()
		for i in range(60):
			await get_tree().create_timer(1.0).timeout
			health.updatePermissionStatus()
			if health.hasStepPermission():
				break
	if not health.hasStepPermission():
		output.text = "Step permission not granted. Check Health Connect app permissions, then tap again."
		busy = false
		return
	output.text = "PASS: Permission granted. Reading today's steps..."
	health.updateTodaySteps()
	for i in range(40):
		await get_tree().create_timer(0.25).timeout
		if health.isTodayStepsReady() or health.getLastError() != "":
			break
	if health.getLastError() != "":
		output.text = "Read failed: " + str(health.getLastError())
	elif not health.isTodayStepsReady():
		output.text = "Read timed out. Tap again."
	else:
		output.text = "PASS: Plugin loaded / Permission granted / Read completed\nToday's steps: " + str(health.getTodaySteps()) + "\nCompare this with Health Connect records. Zero does not prove that step data is syncing."
	busy = false
